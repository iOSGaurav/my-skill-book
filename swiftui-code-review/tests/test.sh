#!/usr/bin/env bash
#
# Tests for the swiftui-code-review scripts. Offline:
#   - collect-diff.sh PR-URL parsing + current diff in a throwaway repo
#   - post-review.sh --print payload construction (no network)
#   - render-report.sh HTML + Markdown output
#
set -uo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPTS="$(cd "$DIR/.." && pwd)/scripts"
FIX="$DIR/fixtures/findings.json"
PASS=0
FAIL=0

ok()   { printf 'ok   %s\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf 'FAIL %s\n' "$1"; FAIL=$((FAIL+1)); }
has()  { printf '%s' "$2" | grep -qF -- "$3" && ok "$1" || bad "$1 — missing: $3"; }

# ---- collect-diff.sh: PR URL parsing ----
T="$("$SCRIPTS/collect-diff.sh" --pr "https://github.com/acme/widgets/pull/77" --print-target 2>/dev/null)"
[ "$T" = "acme/widgets#77" ] && ok "collect: pr url parse" || bad "collect: pr url parse (got '$T')"

if "$SCRIPTS/collect-diff.sh" --pr "https://github.com/acme/widgets/issues/77" --print-target >/dev/null 2>&1; then
  bad "collect: bad pr url should fail"
else
  ok "collect: bad pr url fails"
fi

# ---- collect-diff.sh: current diff in throwaway repo ----
REPO="$(mktemp -d)"
(
  cd "$REPO" && git init -q && git config user.email t@t.co && git config user.name t
  printf 'a\n' > f.swift && git add f.swift && git commit -q -m init
  printf 'a\nb\n' > f.swift
)
DIFF="$(cd "$REPO" && "$SCRIPTS/collect-diff.sh" 2>/dev/null)"
has "collect: current diff shows change" "$DIFF" "+b"
rm -rf "$REPO"

# ---- post-review.sh --print ----
P="$("$SCRIPTS/post-review.sh" --pr "https://github.com/acme/widgets/pull/77" \
      --findings "$FIX" --event REQUEST_CHANGES --commit deadbeef --print 2>/dev/null)"
has "post: commit id"        "$P" '"commit_id": "deadbeef"'
has "post: event"            "$P" '"event": "REQUEST_CHANGES"'
has "post: inline path"      "$P" '"path": "Sources/LoginView.swift"'
has "post: inline line"      "$P" '"line": 42'
has "post: side RIGHT"       "$P" '"side": "RIGHT"'
has "post: severity tag"     "$P" '[Blocker · Memory management]'
has "post: summary verdict"  "$P" 'Request changes'
# count inline comments == number of findings (4)
NC="$(printf '%s' "$P" | grep -c '"side": "RIGHT"')"
[ "$NC" -eq 4 ] && ok "post: 4 inline comments" || bad "post: expected 4 comments, got $NC"

# bad event rejected
if "$SCRIPTS/post-review.sh" --pr "https://github.com/a/b/pull/1" --findings "$FIX" --event NOPE --print >/dev/null 2>&1; then
  bad "post: invalid event should fail"
else
  ok "post: invalid event fails"
fi

# ---- render-report.sh HTML ----
H="$("$SCRIPTS/render-report.sh" --findings "$FIX" --title "PROJ-9" 2>/dev/null)"
has "report html: doctype"   "$H" "<!doctype html>"
has "report html: title"     "$H" "PROJ-9"
has "report html: verdict"   "$H" "Verdict: Request changes"
has "report html: finding"   "$H" "creating a retain cycle"
has "report html: category"  "$H" "[Accessibility]"

# ---- render-report.sh Markdown ----
M="$("$SCRIPTS/render-report.sh" --findings "$FIX" --md 2>/dev/null)"
has "report md: heading"     "$M" "# SwiftUI / iOS Code Review"
has "report md: severity"    "$M" "Blocker (1)"
has "report md: verdict"     "$M" "**Verdict:** Request changes"
has "report md: suggestion"  "$M" "Suggestion: Move the request"

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
