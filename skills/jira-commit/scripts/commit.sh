#!/usr/bin/env bash
#
# commit.sh — commit staged changes with the current branch's Jira ID as prefix.
#
# Usage:
#   commit.sh "<subject>" [--print] [--no-stage]
#
# Produces a commit message of the form:  KEY: <subject>
# where KEY is the Jira issue key found in the current branch name
# (e.g. feature/PROJ-123-add-login -> PROJ-123).
#
# Options:
#   --print     Print "KEY: <subject>" and exit; do not stage or commit.
#   --no-stage  Do not run `git add -A`; commit only what is already staged.
#
set -euo pipefail

die() { printf 'error: %s\n' "$1" >&2; exit "${2:-1}"; }

SUBJECT=""
PRINT=0
STAGE=1

while [ $# -gt 0 ]; do
  case "$1" in
    --print)    PRINT=1; shift ;;
    --no-stage) STAGE=0; shift ;;
    -h|--help)  sed -n '2,17p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)         die "unknown option: $1" ;;
    *)
      [ -z "$SUBJECT" ] || die "unexpected argument: $1"
      SUBJECT="$1"; shift ;;
  esac
done

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git repository"

# ---- derive Jira key from branch -------------------------------------------
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
[ -n "$BRANCH" ] && [ "$BRANCH" != "HEAD" ] || die "could not determine current branch (detached HEAD?)"
KEY="$(printf '%s' "$BRANCH" | grep -ioE '[A-Z][A-Z0-9_]+-[0-9]+' | head -n1 | tr '[:lower:]' '[:upper:]' || true)"
[ -n "$KEY" ] || die "no Jira issue key (e.g. PROJ-123) found in branch name: $BRANCH"

# ---- sanitize subject ------------------------------------------------------
[ -n "$SUBJECT" ] || die "empty commit subject"
# collapse to a single line (first line only, trimmed)
SUBJECT="$(printf '%s' "$SUBJECT" | tr '\n' ' ' | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//; s/[[:space:]]+/ /g')"
# strip a leading duplicate "KEY:" (case-insensitive) to avoid double-prefix
SUBJECT="$(printf '%s' "$SUBJECT" | sed -E "s/^${KEY}:[[:space:]]*//I")"
[ -n "$SUBJECT" ] || die "commit subject is empty after sanitizing"

MESSAGE="$KEY: $SUBJECT"

if [ "$PRINT" -eq 1 ]; then
  printf '%s\n' "$MESSAGE"
  exit 0
fi

# ---- stage + commit --------------------------------------------------------
if [ "$STAGE" -eq 1 ]; then
  git add -A
fi
if git diff --cached --quiet; then
  die "nothing to commit (no staged changes)"
fi

git commit -m "$MESSAGE" >/dev/null
printf 'committed: %s\n' "$MESSAGE"
