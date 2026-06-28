#!/usr/bin/env bash
#
# collect-diff.sh — emit the unified diff to review.
#
# Usage:
#   collect-diff.sh                       # current working diff (git diff HEAD)
#   collect-diff.sh --branch <name> [--base <b>]
#   collect-diff.sh --pr <github-pr-url>
#   collect-diff.sh --pr <url> --print-target   # print owner/repo/number, no fetch
#
# PR mode requires the `gh` CLI, authenticated.
#
set -euo pipefail

die() { printf 'error: %s\n' "$1" >&2; exit "${2:-1}"; }

PR_URL=""
BRANCH=""
BASE=""
PRINT_TARGET=0

while [ $# -gt 0 ]; do
  case "$1" in
    --pr)            PR_URL="${2:-}"; shift 2 ;;
    --branch)        BRANCH="${2:-}"; shift 2 ;;
    --base)          BASE="${2:-}"; shift 2 ;;
    --print-target)  PRINT_TARGET=1; shift ;;
    -h|--help)       sed -n '2,13p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)              die "unknown option: $1" ;;
    *)               die "unexpected argument: $1" ;;
  esac
done

# parse_pr_url <url> -> sets OWNER REPO NUMBER
parse_pr_url() {
  OWNER="$(printf '%s' "$1" | sed -nE 's#^https?://github\.com/([^/]+)/([^/]+)/pull/([0-9]+).*#\1#p')"
  REPO="$(printf '%s' "$1" | sed -nE 's#^https?://github\.com/([^/]+)/([^/]+)/pull/([0-9]+).*#\2#p')"
  NUMBER="$(printf '%s' "$1" | sed -nE 's#^https?://github\.com/([^/]+)/([^/]+)/pull/([0-9]+).*#\3#p')"
  [ -n "$OWNER" ] && [ -n "$REPO" ] && [ -n "$NUMBER" ] || die "not a GitHub PR URL: $1"
}

if [ -n "$PR_URL" ]; then
  parse_pr_url "$PR_URL"
  if [ "$PRINT_TARGET" -eq 1 ]; then
    printf '%s/%s#%s\n' "$OWNER" "$REPO" "$NUMBER"
    exit 0
  fi
  command -v gh >/dev/null 2>&1 || die "gh CLI not found (needed for --pr)"
  gh pr diff "$NUMBER" --repo "$OWNER/$REPO"
  exit 0
fi

# git modes
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git repository"

if [ -n "$BRANCH" ]; then
  if [ -z "$BASE" ]; then
    BASE="$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
    [ -n "$BASE" ] || BASE="main"
  fi
  git diff "$BASE...$BRANCH"
else
  git diff HEAD
fi
