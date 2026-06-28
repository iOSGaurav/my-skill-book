#!/usr/bin/env bash
#
# fetch-story.sh — fetch a Jira story and print a plain-text bundle for subtask
# planning (summary, type, labels, components, description, acceptance criteria,
# and a platform hint).
#
# Usage:
#   fetch-story.sh <jira-url>
#   fetch-story.sh --from-file <json>   # parse a saved API response (no network)
#
# Auth (network mode):
#   JIRA_EMAIL      Atlassian account email
#   JIRA_API_TOKEN  Atlassian API token (HTTP Basic)
#
set -euo pipefail

die() { printf 'error: %s\n' "$1" >&2; exit "${2:-1}"; }

URL=""
FROM_FILE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --from-file) FROM_FILE="${2:-}"; shift 2 ;;
    -h|--help)   sed -n '2,16p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)          die "unknown option: $1" ;;
    *)
      [ -z "$URL" ] || die "unexpected argument: $1"
      URL="$1"; shift ;;
  esac
done

# ---- the python extractor (shared by both modes) ---------------------------
extract() {
  python3 - "$@" <<'PY'
import sys, json, re, html

def strip_html(s):
    if not s:
        return ""
    s = re.sub(r'(?i)</(p|div|li|h[1-6])>', '\n', s)
    s = re.sub(r'(?i)<li[^>]*>', '- ', s)
    s = re.sub(r'(?i)<br\s*/?>', '\n', s)
    s = re.sub(r'<[^>]+>', '', s)
    s = html.unescape(s)
    s = re.sub(r'\n[ \t]+', '\n', s)
    s = re.sub(r'\n{3,}', '\n\n', s)
    return s.strip()

data = json.load(open(sys.argv[1]))
fields = data.get("fields", {}) or {}
rendered = data.get("renderedFields", {}) or {}
names = data.get("names", {}) or {}

summary = fields.get("summary", "") or ""
itype = ((fields.get("issuetype") or {}).get("name")) or ""
labels = fields.get("labels", []) or []
components = [c.get("name", "") for c in (fields.get("components") or [])]
description = strip_html(rendered.get("description", "")) or strip_html(
    fields.get("description", "") if isinstance(fields.get("description"), str) else "")

# acceptance criteria: find a field whose display name mentions "acceptance crit"
ac = ""
for fid, fname in names.items():
    if re.search(r'acceptance\s*crit', str(fname), re.I):
        ac = strip_html(rendered.get(fid, "")) or strip_html(
            fields.get(fid, "") if isinstance(fields.get(fid), str) else "")
        if ac:
            break

# platform hint from labels + components + summary
hay = " ".join(labels + components + [summary]).lower()
has_ios = bool(re.search(r'\bios\b', hay))
has_aos = bool(re.search(r'\b(aos|android)\b', hay))
if has_ios and has_aos:
    hint = "both"
elif has_ios:
    hint = "iOS"
elif has_aos:
    hint = "AOS/Android"
else:
    hint = "unknown"

out = []
out.append(f"Summary: {summary}")
out.append(f"Issue type: {itype}")
out.append(f"Labels: {', '.join(labels) if labels else '(none)'}")
out.append(f"Components: {', '.join([c for c in components if c]) if any(components) else '(none)'}")
out.append(f"Platform hint: {hint}")
out.append("")
out.append("Description:")
out.append(description if description else "(none)")
if ac:
    out.append("")
    out.append("Acceptance Criteria:")
    out.append(ac)
print("\n".join(out))
PY
}

# ---- from-file mode --------------------------------------------------------
if [ -n "$FROM_FILE" ]; then
  [ -f "$FROM_FILE" ] || die "file not found: $FROM_FILE"
  extract "$FROM_FILE"
  exit 0
fi

# ---- network mode ----------------------------------------------------------
[ -n "$URL" ] || die "missing Jira URL (try --help)"

BASE_HOST="$(printf '%s' "$URL" | sed -nE 's#^(https?://[^/]+).*#\1#p')"
KEY="$(printf '%s' "$URL" | sed -nE 's#.*/browse/([A-Za-z][A-Za-z0-9_]+-[0-9]+).*#\1#p')"
if [ -z "$KEY" ]; then
  KEY="$(printf '%s' "$URL" | sed -nE 's#.*[?&]selectedIssue=([A-Za-z][A-Za-z0-9_]+-[0-9]+).*#\1#p')"
fi
[ -n "$BASE_HOST" ] || die "could not parse host from URL: $URL"
[ -n "$KEY" ] || die "could not find a Jira issue key (e.g. PROJ-123) in URL: $URL"
KEY="$(printf '%s' "$KEY" | tr '[:lower:]' '[:upper:]')"

[ -n "${JIRA_EMAIL:-}" ] || die "JIRA_EMAIL is not set"
[ -n "${JIRA_API_TOKEN:-}" ] || die "JIRA_API_TOKEN is not set"

API="$BASE_HOST/rest/api/3/issue/$KEY?expand=names,renderedFields&fields=summary,description,labels,components,issuetype"
BODY="$(mktemp)"
trap 'rm -f "$BODY"' EXIT
CODE="$(curl -sS -o "$BODY" -w '%{http_code}' \
          -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
          -H 'Accept: application/json' \
          "$API")" || die "network error contacting Jira"
case "$CODE" in
  200) : ;;
  401|403) die "Jira authentication failed ($CODE) — check JIRA_EMAIL / JIRA_API_TOKEN" ;;
  404) die "Jira issue not found ($CODE): $KEY" ;;
  *)   die "Jira request failed (HTTP $CODE)" ;;
esac

extract "$BODY"
