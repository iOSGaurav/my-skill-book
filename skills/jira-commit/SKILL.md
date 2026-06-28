---
name: jira-commit
description: Use when the user wants to commit changes or generate a commit message. Generates a plain-English commit message from the current changes and commits with the branch's Jira ID as a prefix (e.g. "PROJ-123: add login button"). Not conventional-commit style.
---

# Jira Commit

Generate a commit message from the current changes and commit it, prefixed with
the Jira ID taken from the current branch name. Message format is
`KEY: <subject>` — full style guide in `references/message-style.md`.

## Fast Path

1. **Stage and review** the changes:
   ```bash
   git add -A && git diff --staged
   ```
2. **Write a subject** — one plain-English line describing *what changed*.
   Imperative mood; no conventional-commit prefix (`feat:`/`fix:`/…); no Jira key
   (the script adds it). See `references/message-style.md`.
3. **Commit** via the helper, which derives the Jira key from the branch and
   prepends it:
   ```bash
   scripts/commit.sh "<your subject>"
   ```

Options:
- `--print` — print `KEY: <subject>` without committing (preview).
- `--no-stage` — commit only what is already staged (skip `git add -A`).

## Guardrails

- Never write a conventional-commit prefix; the Jira key is the only prefix.
- Don't type the Jira key yourself — the script prepends it (a duplicate leading
  `KEY:` is stripped).
- Review the staged diff before writing the subject so it reflects what changed.

## Reference Router

See [`references/_index.md`](references/_index.md):
- `references/message-style.md` — subject rules, why not conventional commits,
  good/bad examples.

## Verification Checklist

1. The subject is a single imperative line with no conventional-commit prefix.
2. The resulting commit reads `KEY: <subject>` with the correct Jira key.
3. On error, relay the script's message — they are actionable (no Jira key in
   branch name, nothing to commit, empty subject, not a git repo).
