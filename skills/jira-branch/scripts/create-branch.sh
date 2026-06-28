#!/usr/bin/env bash
#
# create-branch.sh — create and check out a git branch from a Jira ticket URL.
#
# Usage:
#   create-branch.sh <jira-url> [--base <branch>] [--dry-run]
#                     [--summary <text>] [--type <type>]
#
# Branch format: <prefix>/<KEY>-<slug>
#   prefix = "bugfix" when issue type is "Bug", else "feature"
#   slug   = lowercased summary, [^a-z0-9]+ -> "-", trimmed, capped at 50 chars
#
# Auth (when --summary/--type are not both supplied):
#   JIRA_EMAIL      Atlassian account email
#   JIRA_API_TOKEN  Atlassian API token (HTTP Basic)
#
set -euo pipefail

SLUG_MAX=50

die() { printf 'error: %s\n' "$1" >&2; exit "${2:-1}"; }

usage() {
  sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

# ---- parse args ------------------------------------------------------------
URL=""
BASE_OVERRIDE=""
DRY_RUN=0
SUMMARY_OVERRIDE=""
TYPE_OVERRIDE=""
HAVE_SUMMARY=0
HAVE_TYPE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --base)     BASE_OVERRIDE="${2:-}"; shift 2 ;;
    --summary)  SUMMARY_OVERRIDE="${2:-}"; HAVE_SUMMARY=1; shift 2 ;;
    --type)     TYPE_OVERRIDE="${2:-}"; HAVE_TYPE=1; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    -h|--help)  usage 0 ;;
    -*)         die "unknown option: $1" ;;
    *)
      [ -z "$URL" ] || die "unexpected argument: $1"
      URL="$1"; shift ;;
  esac
done

[ -n "$URL" ] || die "missing Jira URL (try --help)"

# ---- parse URL -------------------------------------------------------------
# Accept https://host/browse/KEY-123 and .../browse/KEY-123?query etc.
BASE_HOST="$(printf '%s' "$URL" | sed -nE 's#^(https?://[^/]+).*#\1#p')"
KEY="$(printf '%s' "$URL" | sed -nE 's#.*/browse/([A-Za-z][A-Za-z0-9_]+-[0-9]+).*#\1#p')"
if [ -z "$KEY" ]; then
  # Fall back to selectedIssue=KEY-123 style URLs.
  KEY="$(printf '%s' "$URL" | sed -nE 's#.*[?&]selectedIssue=([A-Za-z][A-Za-z0-9_]+-[0-9]+).*#\1#p')"
fi
[ -n "$BASE_HOST" ] || die "could not parse host from URL: $URL"
[ -n "$KEY" ] || die "could not find a Jira issue key (e.g. PROJ-123) in URL: $URL"
KEY="$(printf '%s' "$KEY" | tr '[:lower:]' '[:upper:]')"

# ---- fetch ticket ----------------------------------------------------------
slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' \
    | cut -c1-"$SLUG_MAX" \
    | sed -E 's/-+$//'
}

if [ "$HAVE_SUMMARY" -eq 1 ] && [ "$HAVE_TYPE" -eq 1 ]; then
  SUMMARY="$SUMMARY_OVERRIDE"
  ITYPE="$TYPE_OVERRIDE"
else
  [ -n "${JIRA_EMAIL:-}" ] || die "JIRA_EMAIL is not set"
  [ -n "${JIRA_API_TOKEN:-}" ] || die "JIRA_API_TOKEN is not set"
  API="$BASE_HOST/rest/api/3/issue/$KEY?fields=summary,issuetype"
  HTTP_BODY="$(mktemp)"
  trap 'rm -f "$HTTP_BODY"' EXIT
  CODE="$(curl -sS -o "$HTTP_BODY" -w '%{http_code}' \
            -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
            -H 'Accept: application/json' \
            "$API")" || die "network error contacting Jira"
  case "$CODE" in
    200) : ;;
    401|403) die "Jira authentication failed ($CODE) — check JIRA_EMAIL / JIRA_API_TOKEN" ;;
    404) die "Jira issue not found ($CODE): $KEY" ;;
    *)   die "Jira request failed (HTTP $CODE)" ;;
  esac
  SUMMARY="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["fields"]["summary"])' "$HTTP_BODY")"
  ITYPE="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["fields"]["issuetype"]["name"])' "$HTTP_BODY")"
fi

# ---- compute branch name ---------------------------------------------------
case "$ITYPE" in
  [Bb]ug) PREFIX="bugfix" ;;
  *)      PREFIX="feature" ;;
esac
SLUG="$(slugify "$SUMMARY")"
if [ -n "$SLUG" ]; then
  BRANCH="$PREFIX/$KEY-$SLUG"
else
  BRANCH="$PREFIX/$KEY"
fi

# ---- resolve base branch ---------------------------------------------------
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git repository"
if [ -n "$BASE_OVERRIDE" ]; then
  BASE="$BASE_OVERRIDE"
else
  BASE="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
  [ -n "$BASE" ] || BASE="main"
fi

if [ "$DRY_RUN" -eq 1 ]; then
  printf 'branch: %s\nbase:   %s\n' "$BRANCH" "$BASE"
  exit 0
fi

# ---- create + checkout -----------------------------------------------------
if ! git diff --quiet || ! git diff --cached --quiet; then
  printf 'warning: working tree has uncommitted changes; they will carry over to %s\n' "$BRANCH" >&2
fi

git fetch origin "$BASE" >/dev/null 2>&1 || printf 'warning: could not fetch origin/%s; using local refs\n' "$BASE" >&2

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git checkout "$BRANCH"
  printf 'checked out existing branch: %s\n' "$BRANCH"
else
  if git rev-parse --verify --quiet "refs/remotes/origin/$BASE" >/dev/null; then
    git checkout -b "$BRANCH" "origin/$BASE"
  else
    git checkout -b "$BRANCH" "$BASE"
  fi
  printf 'created branch: %s (from %s)\n' "$BRANCH" "$BASE"
fi
