#!/usr/bin/env bash
#
# Tests for commit.sh — key extraction and prefixing, using --print --no-stage
# inside a throwaway git repo (no commits created).
#
set -uo pipefail

SCRIPT="$(cd "$(dirname "$0")/.." && pwd)/scripts/commit.sh"
PASS=0
FAIL=0

REPO="$(mktemp -d)"
cd "$REPO"
git init -q
git config user.email t@t.co
git config user.name t
git commit -q --allow-empty -m init

cleanup() { cd /; rm -rf "$REPO"; }
trap cleanup EXIT

# expect_msg <branch> <expected-message> <subject>
expect_msg() {
  local branch="$1" expected="$2" subject="$3" out
  git checkout -q -B "$branch"
  out="$("$SCRIPT" "$subject" --print --no-stage 2>/dev/null)"
  if [ "$out" = "$expected" ]; then
    printf 'ok   %s\n' "$expected"; PASS=$((PASS+1))
  else
    printf 'FAIL expected %q got %q\n' "$expected" "$out"; FAIL=$((FAIL+1))
  fi
}

# expect_fail <branch> <subject>
expect_fail() {
  local branch="$1" subject="$2"
  git checkout -q -B "$branch"
  if "$SCRIPT" "$subject" --print --no-stage >/dev/null 2>&1; then
    printf 'FAIL expected failure (branch=%s subject=%q)\n' "$branch" "$subject"; FAIL=$((FAIL+1))
  else
    printf 'ok   (failed as expected) branch=%s\n' "$branch"; PASS=$((PASS+1))
  fi
}

# key from typical jira-branch name
expect_msg "feature/PROJ-123-add-login" "PROJ-123: add login button" "add login button"
# bare key branch
expect_msg "PROJ-9" "PROJ-9: tidy imports" "tidy imports"
# bugfix prefix + multi-digit project code
expect_msg "bugfix/AB1-2-fix-crash" "AB1-2: fix the crash" "fix the crash"
# lowercase key in branch is upcased
expect_msg "feature/proj-22-thing" "PROJ-22: do the thing" "do the thing"
# double-prefix guard: subject already starts with KEY:
expect_msg "feature/PROJ-7-x" "PROJ-7: already prefixed" "PROJ-7: already prefixed"
# whitespace/newlines collapsed to single line
expect_msg "PROJ-5" "PROJ-5: a b c" "  a   b
c  "

# no jira key in branch -> failure
expect_fail "main" "some subject"
# empty subject -> failure
expect_fail "feature/PROJ-1-x" ""

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
