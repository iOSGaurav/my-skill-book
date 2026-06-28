---
name: swiftui-code-review
description: Use when reviewing SwiftUI / iOS code changes — a GitHub PR, a branch, or the current working diff. Reviews against a comprehensive parameter checklist (state, performance, concurrency, memory, accessibility, security, testing, etc.) and posts inline PR comments, or generates an HTML/Markdown report.
---

# SwiftUI / iOS Code Review

Review SwiftUI / iOS changes against a comprehensive rubric, then deliver
findings as inline GitHub PR comments (for a PR URL) or as a report.

## Fast Path

1. **Collect the diff** for the requested target:
   ```bash
   scripts/collect-diff.sh --pr "https://github.com/owner/repo/pull/123"
   scripts/collect-diff.sh --branch feature/PROJ-1-x   # vs detected base
   scripts/collect-diff.sh                              # current working diff
   ```
   If the diff is empty, say there is nothing to review and stop.
2. **Review the changed Swift lines** against the rubric (see Reference Router).
   Report only real, actionable issues — not every theoretical concern. Keep
   findings tied to the diff; don't review unrelated existing code.
3. **Build `findings.json`** — one object per finding:
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
   new file (right side of the diff). `category` must match a reference file.
4. **Deliver** (see Delivery below) and **report the verdict**.

## Common Issues Router

| Symptom in the diff | First check | Smallest safe fix | Reference |
|---|---|---|---|
| Networking / logic inside `View.body` | Is this view-only? | Move to model / `.task` | `references/architecture.md`, `references/networking.md` |
| `@ObservedObject` created in `body` | Who owns it? | `@StateObject` (owner) or inject | `references/state-management.md` |
| Heavy work / index-as-id in `ForEach` | Runs every render? | Precompute; stable `id` | `references/performance.md` |
| UI state mutated off main actor | Truly UI-bound? | `@MainActor` / `MainActor.run` | `references/concurrency.md` |
| `self` captured in long-lived `Task` | Long-lived? | `[weak self]` + cancel | `references/memory.md` |
| `try?` / empty `catch` swallowing errors | Actionable failure? | Surface error + state | `references/networking.md` |
| Icon-only button, no label | VoiceOver reachable? | `.accessibilityLabel` | `references/accessibility.md` |
| Hardcoded secret / token in `UserDefaults` | Sensitive? | Config / Keychain | `references/security.md` |
| New logic with no tests | Testable seam? | Add unit/snapshot tests | `references/testing.md` |
| Hardcoded user-facing string | Shipped UI? | `LocalizedStringKey` / catalog | `references/localization.md` |
| `.shared` singleton deep in logic | Needs testing? | Inject a protocol | `references/dependency-injection.md` |
| `v`, force-unwrap, `public` by default | Clear / safe? | Rename / guard / restrict | `references/conventions.md` |
| Debug `print`, dead code, churn | Intentional? | Remove before merge | `references/pr-readiness.md` |

## Delivery

- **PR URL → inline comments** (needs authenticated `gh`):
  ```bash
  scripts/post-review.sh --pr "<url>" --findings findings.json \
    --event REQUEST_CHANGES   # REQUEST_CHANGES if any Blocker/High, else COMMENT
  ```
  Preview the payload without posting: add `--print`.
- **Branch / current diff → report** (HTML default, `--md` for Markdown):
  ```bash
  scripts/render-report.sh --findings findings.json --title "<KEY/branch>" --out review.html
  ```

## Guardrails

- Review the diff, not the whole codebase. Don't flag pre-existing code unless
  the change touches it.
- Every finding cites a `category` that matches a `references/*.md` file.
- Don't invent requirements; base findings on what the code actually does.
- Prefer the smallest safe fix in `suggestion`; don't propose broad rewrites.
- Use `REQUEST_CHANGES` only when there is a Blocker or High; otherwise `COMMENT`.

## Reference Router

Full rubric and per-category detail in [`references/_index.md`](references/_index.md):

- Foundations — `references/architecture.md`, `references/state-management.md`,
  `references/performance.md`
- Runtime correctness — `references/concurrency.md`, `references/memory.md`,
  `references/networking.md`
- User-facing quality — `references/accessibility.md`, `references/localization.md`
- Safety — `references/security.md`
- Maintainability — `references/testing.md`,
  `references/dependency-injection.md`, `references/conventions.md`,
  `references/pr-readiness.md`

## Verification Checklist

1. The diff was actually collected and is non-empty.
2. Each finding has `path`, `line` (right side), `severity`, a `category` that
   matches a reference file, an `issue`, and a `suggestion`.
3. Severity reflects impact (crashes/data-races/security → Blocker/High).
4. Delivery matches input: PR URL → posted review; branch/diff → report file.
5. Report back the verdict (Request changes / Comments only / Looks good), counts
   by severity, and where the output went.
