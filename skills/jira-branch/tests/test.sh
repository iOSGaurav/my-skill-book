#!/usr/bin/env bash
#
# Tests for create-branch.sh name computation, using --dry-run with
# --summary/--type overrides (no Jira, no git mutation).
#
set -uo pipefail

SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/scripts/create-branch.sh"
PASS=0
FAIL=0

# expect_branch <expected-branch> <args...>
expect_branch() {
  local expected="$1"; shift
  local out branch
  out="$("$SCRIPT" "$@" --base main --dry-run 2>/dev/null)"
  branch="$(printf '%s\n' "$out" | sed -nE 's/^branch:[[:space:]]+(.*)$/\1/p')"
  if [ "$branch" = "$expected" ]; then
    printf 'ok   %s\n' "$expected"; PASS=$((PASS+1))
  else
    printf 'FAIL expected %q got %q\n' "$expected" "$branch"; FAIL=$((FAIL+1))
  fi
}

# expect_fail <args...>  — script should exit non-zero
expect_fail() {
  if "$SCRIPT" "$@" --dry-run >/dev/null 2>&1; then
    printf 'FAIL expected failure for: %s\n' "$*"; FAIL=$((FAIL+1))
  else
    printf 'ok   (failed as expected) %s\n' "$1"; PASS=$((PASS+1))
  fi
}

U="https://co.atlassian.net/browse"

# normal story
expect_branch "feature/PROJ-123-add-login-button" \
  "$U/PROJ-123" --summary "Add login button" --type Story
# bug -> bugfix
expect_branch "bugfix/PROJ-456-fix-crash-on-startup" \
  "$U/PROJ-456" --summary "Fix crash on startup" --type Bug
# slug cleanup: symbols, casing, extra spaces
expect_branch "feature/ABC-7-clean-up-this-mess" \
  "$U/ABC-7" --summary "  Clean Up: this  MESS!! " --type Task
# long summary: slug capped at 50 chars (no trailing hyphen)
expect_branch "feature/LONG-1-implement-comprehensive-user-authentication-and-se" \
  "$U/LONG-1" --summary "Implement comprehensive user authentication and session handling" --type Task
# symbol-only summary -> prefix/KEY only
expect_branch "feature/SYM-9" \
  "$U/SYM-9" --summary "!!!@@@###" --type Task
# lowercase key in URL is upcased
expect_branch "feature/PROJ-22-hello" \
  "$U/proj-22" --summary "hello" --type Story
# selectedIssue style URL
expect_branch "feature/QUEUE-5-thing" \
  "https://co.atlassian.net/jira/board?selectedIssue=QUEUE-5" --summary "thing" --type Story

# malformed URL -> failure
expect_fail "https://co.atlassian.net/dashboard" --summary x --type Task
# non-jira garbage -> failure
expect_fail "not-a-url" --summary x --type Task

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
