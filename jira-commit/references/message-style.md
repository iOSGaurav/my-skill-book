# Commit message style

The commit message is `KEY: <subject>`, where `KEY` is the Jira issue key taken
from the current branch name (the script adds it). You write the `<subject>`.

## Format

```
PROJ-123: <subject>
```

- **KEY** — derived from the branch (e.g. `feature/PROJ-123-add-login` →
  `PROJ-123`) by `commit.sh`; you do not type it.
- **subject** — a single, plain-English line describing **what changed**.

## Rules for the subject

- One line, imperative mood ("add", "fix", "remove", "update").
- Describe *what changed*, concisely. Lead with the most important change.
- **Do NOT** use conventional-commit prefixes — no `feat:`, `fix:`, `chore:`,
  `refactor:`, etc.
- Don't restate the Jira key (the script prepends it; a leading duplicate `KEY:`
  is stripped automatically).
- No trailing period; keep it reasonably short.

## Why not conventional commits

This workflow intentionally uses plain messages prefixed with the Jira ID. The
ticket is the source of truth for "type/scope", so a `feat:`/`fix:` prefix is
redundant noise on top of `PROJ-123:`.

## Examples

| Branch | Good subject | Resulting commit |
|---|---|---|
| `feature/PROJ-123-login` | `add login button to header` | `PROJ-123: add login button to header` |
| `bugfix/PROJ-456-crash` | `fix crash when token is missing` | `PROJ-456: fix crash when token is missing` |
| `feature/AB1-2-tidy` | `remove unused imports` | `AB1-2: remove unused imports` |

Avoid: `feat: add login button` (conventional prefix), `PROJ-123: stuff`
(vague), `Updated some files.` (not imperative, no detail).
