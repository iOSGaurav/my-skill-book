# Design: restructure skills to the references format

**Date:** 2026-06-28
**Status:** Approved
**Reference:** https://github.com/AvdLee/Swift-Concurrency-Agent-Skill

## Goal

Adopt the structure of AvdLee's Swift-Concurrency-Agent-Skill across all skills
in this repo, and package the repo as an installable Claude Code plugin.

## Patterns adopted from the reference

1. **Plugin packaging** — `.claude-plugin/plugin.json` + `.claude-plugin/marketplace.json`
   listing the skills (`source: "./"`).
2. **Modular references** — each skill gets a `references/` folder with one
   markdown file per topic plus an `_index.md` (navigation tables + a "Problem
   Router").
3. **Rich SKILL.md** — Fast Path → routing table (issue → smallest safe fix →
   "Reference") → Guardrails → Reference Router → Verification Checklist.

## Scope (confirmed)

- Apply to **all** skills.
- **Keep** existing `agent.md` and helper scripts (the reference has neither, but
  they add real capability here).
- **Add** the plugin manifests.

## Per-skill plan

### swiftui-code-review (full treatment)
Split `parameters.md` into `references/`:
`architecture.md`, `state-management.md`, `performance.md`, `concurrency.md`,
`memory.md`, `networking.md`, `accessibility.md`, `security.md`, `testing.md`,
`localization.md`, `dependency-injection.md`, `conventions.md`,
`pr-readiness.md`, plus `_index.md`. Delete `parameters.md`. Rewrite `SKILL.md`
to the Fast Path / routing-table / reference-router / checklist style. Keep
scripts + `agent.md`; update their `parameters.md` references to `references/`.

### jira-subtasks (medium treatment)
`references/ios.md`, `references/aos.md` (platform subtask templates),
`references/output-format.md`, plus `_index.md`. Rewrite `SKILL.md` to the
reference style. Keep script + agent.

### jira-branch (light treatment)
`references/naming.md` (branch naming rules + examples) + `_index.md`. Rewrite
`SKILL.md` to the reference style. Keep script + agent.

### jira-commit (light treatment)
`references/message-style.md` (plain-message guidance, why not conventional
commits, examples) + `_index.md`. Rewrite `SKILL.md` to the reference style.
Keep script + agent.

## Plugin manifests

`.claude-plugin/plugin.json`:
- `name: my-skill-book`, version, description, author (Gaurav Parmar),
  `repository: https://github.com/iOSGaurav/my-skill-book`, keywords,
  `skills: ["./jira-branch", "./jira-commit", "./jira-subtasks", "./swiftui-code-review"]`.

`.claude-plugin/marketplace.json`:
- marketplace wrapper with a single plugin entry, `source: "./"`.

License field omitted (no LICENSE file in the repo; avoid asserting one).

## Non-goals / notes

- Agents remain as `agent.md` inside each skill folder. The plugin manifest only
  lists `skills` (mirroring the reference); the in-folder agents are companions,
  not auto-registered plugin agents.
- Scripts and their behavior are unchanged; only docs/structure move. All
  existing tests must still pass.

## Verification

- `agent.md` and `SKILL.md` no longer reference deleted files (e.g.
  `parameters.md`).
- All four test suites still pass.
- `plugin.json` / `marketplace.json` are valid JSON and point at existing dirs.
