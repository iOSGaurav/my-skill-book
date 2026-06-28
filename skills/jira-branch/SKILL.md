---
name: jira-branch
description: Use when the user wants to create, start, or check out a git branch from a Jira ticket or Jira URL (e.g. "make a branch for PROJ-123" or pastes an Atlassian browse link). Fetches the ticket summary and type and creates a conventionally named branch.
---

# Jira Branch

Create and check out a git branch named from a Jira ticket. Branch format is
`<prefix>/<KEY>-<slug>` (e.g. `feature/PROJ-123-add-login-button`) — full rules
in `references/naming.md`.

## Prerequisites

Jira Cloud API token, exported as environment variables (HTTP Basic auth):
- `JIRA_EMAIL` — your Atlassian account email
- `JIRA_API_TOKEN` — https://id.atlassian.com/manage-profile/security/api-tokens

Must be run inside a git repository.

## Fast Path

```bash
scripts/create-branch.sh "https://yourco.atlassian.net/browse/PROJ-123"
```

The script parses the URL → fetches summary + issue type from the Jira REST API →
computes the branch name (`references/naming.md`) → fetches the base branch →
creates and checks out the new branch from it.

Options:
- `--base <branch>` — base off a specific branch (default: detected
  `origin/HEAD`, else `main`)
- `--dry-run` — print the computed branch name and base; make no changes
- `--summary <text> --type <type>` — skip the Jira fetch and supply details
  manually

## Guardrails

- Run inside the target git repository.
- Use `--dry-run` first if you want to preview the name before mutating git.
- If the branch already exists, the script checks it out instead of failing.

## Reference Router

See [`references/_index.md`](references/_index.md):
- `references/naming.md` — branch format, type→prefix mapping, slug rules, base
  branch resolution, examples.

## Verification Checklist

1. The reported branch name matches the format in `references/naming.md`.
2. The branch was created from (or checked out against) the intended base.
3. On error, relay the script's message — they are actionable (auth failure,
   unknown key, not a git repo, etc.).
