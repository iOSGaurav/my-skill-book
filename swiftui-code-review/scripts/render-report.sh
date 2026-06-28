#!/usr/bin/env bash
#
# render-report.sh — render findings.json as a review report.
#
# Usage:
#   render-report.sh --findings <json> [--md] [--title <t>] [--out <path>]
#
# Default output is self-contained HTML; --md renders Markdown.
# Writes to --out if given, else stdout.
#
# findings.json: array of { path, line, severity, category, issue, suggestion }
#
set -euo pipefail

die() { printf 'error: %s\n' "$1" >&2; exit "${2:-1}"; }

FINDINGS=""
FORMAT="html"
TITLE="SwiftUI / iOS Code Review"
OUT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --findings) FINDINGS="${2:-}"; shift 2 ;;
    --md)       FORMAT="md"; shift ;;
    --title)    TITLE="${2:-}"; shift 2 ;;
    --out)      OUT="${2:-}"; shift 2 ;;
    -h|--help)  sed -n '2,11p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)         die "unknown option: $1" ;;
    *)          die "unexpected argument: $1" ;;
  esac
done

[ -n "$FINDINGS" ] || die "missing --findings <json>"
[ -f "$FINDINGS" ] || die "findings file not found: $FINDINGS"

REPORT="$(python3 - "$FINDINGS" "$FORMAT" "$TITLE" <<'PY'
import json, sys, html

findings_path, fmt, title = sys.argv[1], sys.argv[2], sys.argv[3]
with open(findings_path) as f:
    findings = json.load(f)
if not isinstance(findings, list):
    sys.exit("findings.json must be a JSON array")

ORDER = ["Blocker", "High", "Medium", "Low", "Nit"]
EMOJI = {"Blocker": "🔴", "High": "🟠", "Medium": "🟡", "Low": "🔵", "Nit": "⚪"}

def norm_sev(s):
    s = (s or "").strip().capitalize()
    return s if s in ORDER else "Medium"

groups = {k: [] for k in ORDER}
for it in findings:
    groups[norm_sev(it.get("severity"))].append(it)
counts = {k: len(groups[k]) for k in ORDER}
total = sum(counts.values())
verdict = "Request changes" if (counts["Blocker"] or counts["High"]) else (
    "Comments only" if total else "Looks good")
summary = ", ".join(f"{counts[k]} {k}" for k in ORDER if counts[k]) or "no findings"

def loc(it):
    p, l = it.get("path", "?"), it.get("line", "?")
    return f"{p}:{l}"

if fmt == "md":
    out = [f"# {title}", "", f"**Findings:** {summary}  ", f"**Verdict:** {verdict}", ""]
    for k in ORDER:
        if not groups[k]:
            continue
        out.append(f"## {EMOJI[k]} {k} ({counts[k]})")
        out.append("")
        for it in groups[k]:
            out.append(f"- **{loc(it)}** — {it.get('issue','').strip()} _[{it.get('category','General')}]_")
            sug = it.get("suggestion", "").strip()
            if sug:
                out.append(f"  - Suggestion: {sug}")
        out.append("")
    print("\n".join(out))
else:
    e = html.escape
    rows = []
    for k in ORDER:
        if not groups[k]:
            continue
        rows.append(f'<h2 class="sev {k.lower()}">{EMOJI[k]} {e(k)} ({counts[k]})</h2>')
        for it in groups[k]:
            sug = it.get("suggestion", "").strip()
            sug_html = f'<div class="sug"><b>Suggestion:</b> {e(sug)}</div>' if sug else ""
            rows.append(
                f'<div class="finding {k.lower()}">'
                f'<div class="loc">{e(loc(it))} '
                f'<span class="cat">[{e(it.get("category","General"))}]</span></div>'
                f'<div class="issue">{e(it.get("issue","").strip())}</div>'
                f'{sug_html}</div>')
    body = "\n".join(rows) if rows else "<p>No findings.</p>"
    print(f"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{e(title)}</title>
<style>
 body{{font-family:-apple-system,Segoe UI,Roboto,sans-serif;max-width:900px;margin:2rem auto;padding:0 1rem;color:#1d1d1f;line-height:1.5}}
 h1{{font-size:1.6rem}} h2.sev{{margin-top:1.6rem;font-size:1.1rem}}
 .verdict{{font-weight:600;padding:.5rem .8rem;border-radius:8px;background:#f2f2f7;display:inline-block}}
 .finding{{border-left:4px solid #c7c7cc;background:#fafafa;padding:.6rem .8rem;margin:.5rem 0;border-radius:0 8px 8px 0}}
 .finding.blocker{{border-color:#ff3b30}} .finding.high{{border-color:#ff9500}}
 .finding.medium{{border-color:#ffcc00}} .finding.low{{border-color:#007aff}} .finding.nit{{border-color:#8e8e93}}
 .loc{{font-family:ui-monospace,Menlo,monospace;font-size:.85rem;color:#6e6e73}}
 .cat{{color:#8e8e93}} .issue{{margin:.2rem 0}} .sug{{font-size:.92rem;color:#3a3a3c}}
</style></head><body>
<h1>{e(title)}</h1>
<p><span class="verdict">Verdict: {e(verdict)}</span> &nbsp; <b>Findings:</b> {e(summary)}</p>
{body}
</body></html>""")
PY
)" || die "failed to render report"

if [ -n "$OUT" ]; then
  printf '%s\n' "$REPORT" > "$OUT"
  printf 'wrote %s report to %s\n' "$FORMAT" "$OUT"
else
  printf '%s\n' "$REPORT"
fi
