#!/usr/bin/env bash
#
# post-review.sh — post findings.json as a single GitHub PR review with inline
# comments.
#
# Usage:
#   post-review.sh --pr <github-pr-url> --findings <json>
#                  [--event REQUEST_CHANGES|COMMENT|APPROVE]
#                  [--commit <sha>] [--print]
#
# findings.json: array of { path, line, severity, category, issue, suggestion }
#
# --print   build the review payload and print it; do not call the network.
# --commit  use this head SHA instead of resolving it via gh (offline/testing).
#
# Posting requires the `gh` CLI, authenticated.
#
set -euo pipefail

die() { printf 'error: %s\n' "$1" >&2; exit "${2:-1}"; }

PR_URL=""
FINDINGS=""
EVENT="COMMENT"
COMMIT=""
PRINT=0

while [ $# -gt 0 ]; do
  case "$1" in
    --pr)        PR_URL="${2:-}"; shift 2 ;;
    --findings)  FINDINGS="${2:-}"; shift 2 ;;
    --event)     EVENT="${2:-}"; shift 2 ;;
    --commit)    COMMIT="${2:-}"; shift 2 ;;
    --print)     PRINT=1; shift ;;
    -h|--help)   sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)          die "unknown option: $1" ;;
    *)           die "unexpected argument: $1" ;;
  esac
done

[ -n "$PR_URL" ] || die "missing --pr <url>"
[ -n "$FINDINGS" ] || die "missing --findings <json>"
[ -f "$FINDINGS" ] || die "findings file not found: $FINDINGS"
case "$EVENT" in
  REQUEST_CHANGES|COMMENT|APPROVE) : ;;
  *) die "invalid --event: $EVENT (REQUEST_CHANGES|COMMENT|APPROVE)" ;;
esac

OWNER="$(printf '%s' "$PR_URL" | sed -nE 's#^https?://github\.com/([^/]+)/([^/]+)/pull/([0-9]+).*#\1#p')"
REPO="$(printf '%s' "$PR_URL" | sed -nE 's#^https?://github\.com/([^/]+)/([^/]+)/pull/([0-9]+).*#\2#p')"
NUMBER="$(printf '%s' "$PR_URL" | sed -nE 's#^https?://github\.com/([^/]+)/([^/]+)/pull/([0-9]+).*#\3#p')"
[ -n "$OWNER" ] && [ -n "$REPO" ] && [ -n "$NUMBER" ] || die "not a GitHub PR URL: $PR_URL"

# resolve head sha
if [ -z "$COMMIT" ]; then
  if [ "$PRINT" -eq 1 ]; then
    COMMIT="<HEAD_SHA>"
  else
    command -v gh >/dev/null 2>&1 || die "gh CLI not found (needed to post)"
    COMMIT="$(gh api "repos/$OWNER/$REPO/pulls/$NUMBER" --jq .head.sha)" \
      || die "could not resolve PR head SHA via gh"
  fi
fi

# build the review payload from findings.json
PAYLOAD="$(python3 - "$FINDINGS" "$COMMIT" "$EVENT" <<'PY'
import json, sys

findings_path, commit, event = sys.argv[1], sys.argv[2], sys.argv[3]
with open(findings_path) as f:
    findings = json.load(f)
if not isinstance(findings, list):
    sys.exit("findings.json must be a JSON array")

ORDER = ["Blocker", "High", "Medium", "Low", "Nit"]
EMOJI = {"Blocker": "🔴", "High": "🟠", "Medium": "🟡", "Low": "🔵", "Nit": "⚪"}

def norm_sev(s):
    s = (s or "").strip().capitalize()
    return s if s in ORDER else "Medium"

comments = []
counts = {k: 0 for k in ORDER}
for it in findings:
    sev = norm_sev(it.get("severity"))
    counts[sev] += 1
    cat = it.get("category", "General")
    issue = it.get("issue", "").strip()
    suggestion = it.get("suggestion", "").strip()
    body = f"**[{sev} · {cat}]** {issue}"
    if suggestion:
        body += f"\n\n**Suggestion:** {suggestion}"
    path = it.get("path")
    line = it.get("line")
    if path and line:
        comments.append({"path": path, "line": int(line), "side": "RIGHT", "body": body})

total = sum(counts.values())
summary = ["## SwiftUI / iOS Code Review", ""]
summary.append("**Findings:** " + ", ".join(
    f"{EMOJI[k]} {counts[k]} {k}" for k in ORDER if counts[k]) or "none")
verdict = "Request changes" if (counts["Blocker"] or counts["High"]) else (
    "Comments only" if total else "Looks good")
summary.append("")
summary.append(f"**Verdict:** {verdict}")

payload = {
    "commit_id": commit,
    "event": event,
    "body": "\n".join(summary),
    "comments": comments,
}
print(json.dumps(payload, indent=2, ensure_ascii=False))
PY
)" || die "failed to build review payload"

if [ "$PRINT" -eq 1 ]; then
  printf '%s\n' "$PAYLOAD"
  exit 0
fi

printf '%s' "$PAYLOAD" | gh api --method POST \
  "repos/$OWNER/$REPO/pulls/$NUMBER/reviews" --input - >/dev/null \
  || die "failed to post review via gh"
printf 'posted review to %s/%s#%s (%s)\n' "$OWNER" "$REPO" "$NUMBER" "$EVENT"
