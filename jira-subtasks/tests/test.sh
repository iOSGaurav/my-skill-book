#!/usr/bin/env bash
#
# Tests for fetch-story.sh extraction, using --from-file with JSON fixtures
# (no network). Verifies the text bundle, acceptance-criteria discovery, and
# platform-hint detection.
#
set -uo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$(cd "$DIR/.." && pwd)/scripts/fetch-story.sh"
FIX="$DIR/fixtures"
PASS=0
FAIL=0

# assert_contains <label> <output> <needle>
assert_contains() {
  if printf '%s' "$2" | grep -qF -- "$3"; then
    printf 'ok   %s\n' "$1"; PASS=$((PASS+1))
  else
    printf 'FAIL %s — missing: %q\n' "$1" "$3"; FAIL=$((FAIL+1))
  fi
}

# --- iOS fixture ---
IOS_OUT="$("$SCRIPT" --from-file "$FIX/ios-story.json" 2>/dev/null)"
assert_contains "ios: summary"         "$IOS_OUT" "Summary: Add login button to header"
assert_contains "ios: platform hint"   "$IOS_OUT" "Platform hint: iOS"
assert_contains "ios: description text" "$IOS_OUT" "Users need a way to sign in from the header."
assert_contains "ios: AC section"       "$IOS_OUT" "Acceptance Criteria:"
assert_contains "ios: AC bullet"        "$IOS_OUT" "- Tapping it presents the login sheet"
assert_contains "ios: html stripped"    "$IOS_OUT" "VoiceOver announces the button"

# --- Android fixture ---
AND_OUT="$("$SCRIPT" --from-file "$FIX/android-story.json" 2>/dev/null)"
assert_contains "android: platform hint" "$AND_OUT" "Platform hint: AOS/Android"
assert_contains "android: component"     "$AND_OUT" "Components: Android"
assert_contains "android: entity decode" "$AND_OUT" "theme & notification preferences"
# no AC field present -> section omitted
if printf '%s' "$AND_OUT" | grep -qF "Acceptance Criteria:"; then
  printf 'FAIL android: AC section should be absent\n'; FAIL=$((FAIL+1))
else
  printf 'ok   android: AC section absent\n'; PASS=$((PASS+1))
fi

# --- malformed URL (network mode) should fail ---
if "$SCRIPT" "https://co.atlassian.net/dashboard" >/dev/null 2>&1; then
  printf 'FAIL malformed URL should fail\n'; FAIL=$((FAIL+1))
else
  printf 'ok   (failed as expected) malformed URL\n'; PASS=$((PASS+1))
fi

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
