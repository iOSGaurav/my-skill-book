# Design: `jira-commit` skill + agent

**Date:** 2026-06-28
**Status:** Approved

## Goal

Generate a commit message from the current changes, prefixed with the Jira ID,
and create the commit. Plain-English messages — **not** conventional-commit style.

Deliverables: a **skill** (`jira-commit`) that pairs Claude's message generation
with a deterministic helper script, plus a thin **agent** (`jira-committer`).

## Decisions (from brainstorming)

- **Jira ID source:** the current git branch name (e.g. `feature/PROJ-123-add-login`
  → `PROJ-123`). Error if no key is found.
- **Prefix format:** `KEY: message`, e.g. `PROJ-123: add login button to header`.
- **Scope & commit:** `git add -A` (stage everything), then commit.
- **Message structure:** single-line subject only.
- **Not conventional commits:** no `feat:`/`fix:`/`chore:` type prefixes.

## Split: LLM + script

Message *content* requires reading the diff (LLM work); the prefix and commit must
be exact (script work).

- **Claude:** stages, reads `git diff --staged`, writes a plain one-line subject.
- **Script:** derives the Jira key from the branch and commits as `KEY: <subject>`,
  guaranteeing the prefix.

## Repo structure

```
skills/jira-commit/
  SKILL.md
  scripts/commit.sh
agents/jira-committer.md
tests/test-jira-commit.sh
```

## Component: `scripts/commit.sh`

**Usage:** `commit.sh "<subject>" [--print] [--no-stage]`

1. Must be inside a git work tree.
2. Derive `KEY` from the current branch with regex `[A-Z][A-Z0-9_]+-[0-9]+`
   (case-insensitive match, upcased). Error if none found.
3. Require a non-empty subject argument.
4. Unless `--no-stage`: run `git add -A`.
5. Require staged changes (`git diff --cached --quiet` must fail); else error
   "nothing to commit".
6. Sanitize subject: collapse to a single line; strip a leading duplicate
   `KEY:` if present (avoid double-prefix).
7. `--print`: print `KEY: <subject>` and exit without committing.
   Otherwise: `git commit -m "KEY: <subject>"` and report the result.

## Component: `skills/jira-commit/SKILL.md`

- Frontmatter `name: jira-commit`; `description:` triggers on "commit",
  "commit message", "commit these changes".
- Body: run `git add -A`, inspect `git diff --staged`, write a concise plain
  subject describing *what changed* (explicitly NOT conventional-commit style),
  then call `scripts/commit.sh "<subject>"`. Report the final commit message.

## Component: `agents/jira-committer.md`

- Subagent. Tools: `Bash`, `Read`.
- Prompt: stage, read the diff, compose a plain subject, call `commit.sh`,
  report the resulting commit. All prefix/commit logic stays in the script.

## Error handling

Clear, actionable failures for: not a git repo, no Jira key in branch name,
empty subject, nothing to commit.

## Testing

`--print` + `--no-stage` make key extraction and prefixing testable without
committing. Cases: key from `feature/PROJ-123-x`, bare `PROJ-9`,
`bugfix/AB1-2-y`; double-prefix guard (subject already starts with `KEY:`);
empty-subject failure; and no-key-in-branch failure.
