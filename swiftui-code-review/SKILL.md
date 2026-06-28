---
name: swiftui-code-review
description: Use when reviewing SwiftUI / iOS code changes — a GitHub PR, a branch, or the current working diff. Reviews against a comprehensive parameter checklist (state, performance, concurrency, memory, accessibility, security, testing, etc.) and posts inline PR comments, or generates an HTML/Markdown report.
---

# SwiftUI / iOS Code Review

Review SwiftUI / iOS changes against a comprehensive set of parameters, then
deliver findings as inline GitHub PR comments (for a PR URL) or as a report.

The full rubric is in [`parameters.md`](parameters.md) — read it and cite a
category for every finding.

## Workflow

1. **Collect the diff** for the requested target:
   ```bash
   scripts/collect-diff.sh --pr "https://github.com/owner/repo/pull/123"
   scripts/collect-diff.sh --branch feature/PROJ-1-x   # vs detected base
   scripts/collect-diff.sh                              # current working diff
   ```

2. **Review** the Swift changes against `parameters.md`. Focus on the changed
   lines. Report only real, actionable issues — not every theoretical concern.

3. **Build `findings.json`** — a JSON array; one object per finding:
   ```json
   [
     {
       "path": "Sources/LoginView.swift",
       "line": 42,
       "severity": "Blocker",
       "category": "Memory management",
       "issue": "Task closure captures self strongly, creating a retain cycle.",
       "suggestion": "Capture [weak self] and guard at the top of the closure."
     }
   ]
   ```
   `severity` ∈ Blocker / High / Medium / Low / Nit. `line` is the line in the
   new file (right side of the diff).

4. **Deliver:**
   - **PR URL** → post inline comments:
     ```bash
     scripts/post-review.sh --pr "<url>" --findings findings.json \
       --event REQUEST_CHANGES   # use REQUEST_CHANGES if any Blocker/High, else COMMENT
     ```
     Preview without posting: add `--print`.
   - **Branch / current diff** → generate a report (HTML default):
     ```bash
     scripts/render-report.sh --findings findings.json --title "<KEY/branch>" --out review.html
     scripts/render-report.sh --findings findings.json --md --out review.md   # markdown
     ```

5. **Report back** the verdict (Request changes / Comments only / Looks good),
   the finding counts, and where the output went (PR review posted, or report path).

## Notes

- Posting to a PR requires the `gh` CLI, authenticated.
- If the diff is empty, say there is nothing to review.
- Keep findings tied to the diff; don't review unrelated existing code.
