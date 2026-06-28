---
name: jira-commit
description: Use when the user wants to commit changes or generate a commit message. Generates a plain-English commit message from the current changes and commits with the branch's Jira ID as a prefix (e.g. "PROJ-123: add login button"). Not conventional-commit style.
---

# Jira Commit

Generate a commit message from the current changes and commit it, prefixed with
the Jira ID taken from the current branch name.

Message format: `KEY: <subject>` — e.g. `PROJ-123: add login button to header`.

- The Jira key comes from the current branch (e.g. `feature/PROJ-123-add-login`).
- The subject is a single plain-English line describing **what changed**.
- **Do NOT** use conventional-commit prefixes (`feat:`, `fix:`, `chore:`, etc.).

## How to use

1. Stage and review the changes:
   ```bash
   git add -A && git diff --staged
   ```
2. Write a concise, plain one-line subject describing what changed. Imperative
   mood, no `feat:`/`fix:` type prefix, no Jira key (the script adds it).
3. Commit via the helper, which derives the Jira key from the branch and prepends it:
   ```bash
   scripts/commit.sh "<your subject>"
   ```

Options:
- `--print` — print `KEY: <subject>` without committing (preview).
- `--no-stage` — commit only what is already staged (skip `git add -A`).

## What to report back

Report the final commit message (`KEY: <subject>`). If the script errors, relay
the message — they are actionable (no Jira key in branch name, nothing to commit,
empty subject, not a git repo).
