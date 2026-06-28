---
name: jira-branch
description: Use when the user wants to create, start, or check out a git branch from a Jira ticket or Jira URL (e.g. "make a branch for PROJ-123" or pastes an Atlassian browse link). Fetches the ticket summary and type and creates a conventionally named branch.
---

# Jira Branch

Create and check out a git branch named from a Jira ticket.

Branch format: `<prefix>/<KEY>-<slug>`
- `prefix` = `bugfix` when the Jira issue type is **Bug**, otherwise `feature`
- `slug` = lowercased summary, non-alphanumerics collapsed to `-`, capped at 50 chars
- Example: `feature/PROJ-123-add-login-button`

## Prerequisites

Set these environment variables (Jira Cloud API token, HTTP Basic auth):
- `JIRA_EMAIL` — your Atlassian account email
- `JIRA_API_TOKEN` — an API token from https://id.atlassian.com/manage-profile/security/api-tokens

Must be run inside a git repository.

## How to use

Run the worker script with the Jira URL:

```bash
scripts/create-branch.sh "https://yourco.atlassian.net/browse/PROJ-123"
```

The script: parses the URL → fetches summary + issue type from the Jira REST API →
computes the branch name → fetches the base branch → creates and checks out the new
branch from it.

Options:
- `--base <branch>` — base off a specific branch (default: detected `origin/HEAD`, else `main`)
- `--dry-run` — print the computed branch name and base, make no changes
- `--summary <text> --type <type>` — skip the Jira fetch and supply details manually

## What to report back

After running, tell the user the branch that was created (or checked out) and the base
it came from. If the script exits with an error, relay the error message — it is written
to be actionable (auth failure, unknown key, not a git repo, etc.).
