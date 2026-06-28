# Design: `swiftui-code-review` skill + agent

**Date:** 2026-06-28
**Status:** Approved

## Goal

Review SwiftUI / iOS code changes against a comprehensive set of review
parameters. Input may be a GitHub PR URL, a branch, or the current working diff.
For a PR URL the review is posted as inline PR comments; otherwise an HTML
report (Markdown optional) is generated with the same content.

Deliverables: a **skill** (`swiftui-code-review`) with a comprehensive parameter
reference and deterministic helper scripts, plus a thin **agent**
(`swiftui-reviewer`).

## Decisions (from brainstorming)

- **Scope:** comprehensive iOS — view layer, architecture, concurrency, memory,
  networking, accessibility, security, testing, localization, DI, conventions,
  PR readiness.
- **Input:** GitHub PR URL, a branch (diff vs base), or the current working diff.
- **Output:** PR URL → inline GitHub PR review comments; branch/current diff →
  HTML report by default (`--md` for Markdown).
- **Finding model:** each finding is `{ path, line, severity, category, issue,
  suggestion }`. Severity ∈ Blocker / High / Medium / Low / Nit.

## Split: LLM + scripts

Review judgment is LLM work; deterministic work is scripted. Claude and the
scripts communicate via a `findings.json` array (the finding model above).

## Repo structure

```
swiftui-code-review/
  SKILL.md
  agent.md
  parameters.md
  scripts/
    collect-diff.sh
    post-review.sh
    render-report.sh
  tests/
    test.sh
    fixtures/findings.json
```

## Component: `parameters.md`

The comprehensive review reference (the rubric). Categories, each with concrete
checks:

- **Architecture & data flow** — separation of concerns, view/model boundaries,
  single source of truth.
- **State management** — correct use of `@State`, `@Binding`, `@StateObject`
  (ownership) vs `@ObservedObject` (injected), `@Environment`,
  `@EnvironmentObject`; no business logic in views.
- **View decomposition & performance** — small views, expensive work out of
  `body`, stable identities in `ForEach`, avoid unnecessary re-evaluation.
- **Concurrency** — `async/await`, `@MainActor` for UI, actor isolation, no
  blocking the main thread, `.task` lifecycle.
- **Memory** — retain cycles, `[weak self]` in closures/Tasks, cancellation.
- **Networking & error handling** — no silent failures, typed errors, user-
  visible error states, no network in `body`.
- **Accessibility** — labels/traits/values, Dynamic Type, VoiceOver order,
  contrast, hit targets.
- **Security** — no hardcoded secrets, Keychain for sensitive data, ATS, safe
  logging.
- **Testing & snapshot coverage** — unit tests for logic, snapshot/UI tests for
  views, edge cases.
- **Localization** — no hardcoded user-facing strings, format/pluralization.
- **Dependency injection** — dependencies injected, not constructed inline;
  testable seams.
- **Naming & conventions** — Swift API design guidelines, consistency with the
  codebase.
- **PR readiness** — scope, dead code, TODOs, docs, no debug prints.

## Component: `scripts/collect-diff.sh`

**Usage:** `collect-diff.sh [--pr <url> | --branch <name> [--base <b>]]`
(default: current working diff)

- `--pr <url>`: parse `owner/repo/number`; `gh pr diff <number> --repo owner/repo`.
- `--branch <name>`: `git diff <base>...<name>` (base default: detected
  `origin/HEAD`, else `main`).
- default: `git diff HEAD`.
- Emits the unified diff to stdout. Errors on a malformed PR URL.

## Component: `scripts/post-review.sh`

**Usage:** `post-review.sh --pr <url> --findings <json>
[--event REQUEST_CHANGES|COMMENT|APPROVE] [--commit <sha>] [--print]`

- Parse `owner/repo/number` from the URL.
- Resolve head SHA via `gh api repos/owner/repo/pulls/number --jq .head.sha`,
  unless `--commit` is given (offline/testing).
- Build a single review payload: `{ commit_id, event, body, comments: [{ path,
  line, side: "RIGHT", body }] }`. Each comment body includes the
  `[severity · category]` tag, the issue, and the suggestion. The review body is
  a severity-grouped summary with counts and a verdict.
- `--print`: print the JSON payload and exit (no network). Otherwise POST via
  `gh api --method POST repos/owner/repo/pulls/number/reviews --input -`.
- Default event: `COMMENT` (use `REQUEST_CHANGES` when blockers exist — the
  skill decides and passes `--event`).

## Component: `scripts/render-report.sh`

**Usage:** `render-report.sh --findings <json> [--md] [--title <t>] [--out <path>]`

- Default: render a styled, self-contained HTML report; `--md` renders Markdown.
- Findings grouped by severity, each showing `path:line`, the `[category]` tag,
  the issue, and the suggestion. Header shows the title and a verdict line with
  counts.
- Writes to `--out` if given, else stdout.

## Component: `SKILL.md`

Triggers on "review this SwiftUI/iOS code", "review this PR", "code review".
Flow:
1. Determine target (PR URL / branch / current diff) and run `collect-diff.sh`.
2. Review the Swift changes against `parameters.md`; produce `findings.json`
   (only real, actionable findings; cite the parameter category).
3. PR URL → `post-review.sh` (pass `--event REQUEST_CHANGES` if any Blocker).
   Branch/current diff → `render-report.sh` (HTML default).
4. Report the verdict and where the output went.

## Component: `agent.md`

Subagent. Tools: `Bash`, `Read`. Runs the flow; posts the PR review or generates
the report; reports the verdict. Reads `parameters.md` as the rubric. Does not
modify source code.

## Error handling

Clear, actionable failures for: malformed PR URL, `gh` not available/auth (post
mode), not a git repo (branch/current modes), empty diff (nothing to review),
malformed `findings.json`.

## Testing (offline)

- **collect-diff.sh**: PR-URL parsing (owner/repo/number) via a `--print-target`
  helper or by asserting the gh command is constructed; bad-URL failure;
  current-diff against a throwaway repo.
- **post-review.sh** `--print --commit <fake>` with `fixtures/findings.json`:
  assert the payload has one inline comment per finding (`path`, `line`,
  `side: "RIGHT"`) and a severity-grouped summary body.
- **render-report.sh**: assert HTML (default) and `--md` outputs contain the
  findings text, severity sections, and a verdict line.

`gh`-dependent posting is exercised only via `--print` (no network).
