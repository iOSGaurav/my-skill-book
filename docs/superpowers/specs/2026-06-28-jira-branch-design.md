# Design: `jira-branch` skill + agent

**Date:** 2026-06-28
**Status:** Approved

## Goal

Given a Jira ticket URL, create and check out a well-named git branch derived
from the ticket's key, issue type, and summary.

Deliverables: a reusable Claude Code **skill** (`jira-branch`) backed by a
deterministic shell script, plus a thin **agent** (`jira-brancher`) that wraps it.

## Decisions (from brainstorming)

- **Jira access:** REST API v3 with token auth (`JIRA_EMAIL` + `JIRA_API_TOKEN`,
  HTTP Basic). Base URL and ticket key are derived from the pasted URL.
- **Branch format:** `type/KEY-slug`, e.g. `feature/PROJ-123-add-login-button`.
- **Type mapping:** issue type `Bug` → `bugfix`; everything else → `feature`.
- **Git actions:** update the base branch (fetch), then create + checkout the
  new branch from it. No push.
- **Base branch:** auto-detected default branch via
  `git symbolic-ref refs/remotes/origin/HEAD`, falling back to `main`.
- **Slug:** lowercase the summary, replace `[^a-z0-9]+` with `-`, trim leading/
  trailing `-`, cap at 50 characters.

## Repo structure (Claude Code plugin layout)

```
skills/
  jira-branch/
    SKILL.md            # workflow doc + when-to-use
    scripts/
      create-branch.sh  # the deterministic worker
agents/
  jira-brancher.md      # subagent that wraps the skill
```

## Component: `scripts/create-branch.sh`

**Usage:** `create-branch.sh <jira-url> [--base <branch>] [--dry-run] [--summary <text>] [--type <type>]`

The `--summary`/`--type` overrides skip the Jira fetch and exist for testing and
for cases where the user wants to supply details manually.

**Steps:**

1. **Parse URL** → extract base URL (e.g. `https://co.atlassian.net`) and key
   (e.g. `PROJ-123`). Accept `.../browse/KEY` and query-string variants. Error
   if the URL is not a recognizable Jira issue URL.
2. **Preflight:**
   - Must be inside a git work tree (`git rev-parse --is-inside-work-tree`).
   - Unless summary+type are both supplied, require `JIRA_EMAIL` and
     `JIRA_API_TOKEN`.
   - Each failure prints a clear, actionable message and exits non-zero.
3. **Fetch ticket** (unless overridden):
   `curl -fsS -u "$JIRA_EMAIL:$JIRA_API_TOKEN" "$BASE/rest/api/3/issue/$KEY?fields=summary,issuetype"`.
   Parse JSON with `python3` (no `jq` dependency). Map HTTP status to friendly
   errors: 401/403 → auth, 404 → unknown key.
4. **Compute name:** `prefix = (issuetype == "Bug") ? "bugfix" : "feature"`;
   `slug` per the slug rule above; result = `${prefix}/${KEY}-${slug}`. If the
   summary is empty after slugifying, use just `${prefix}/${KEY}`.
5. **Git:** resolve base branch (flag > `origin/HEAD` > `main`);
   `git fetch origin <base>`; create + checkout the branch from `origin/<base>`.
   If the branch already exists locally, check it out instead of failing. If the
   working tree is dirty, warn before switching.
6. **`--dry-run`:** print the computed branch name and the resolved base, then
   stop before any git mutation.

**Output:** on success, print the created branch name and the base it came from,
in a form the skill/agent can relay to the user.

## Component: `skills/jira-branch/SKILL.md`

- Frontmatter: `name: jira-branch`; `description:` triggers on phrasing like
  "create/start a branch from a Jira ticket/URL".
- Body: when to use, required env vars (`JIRA_EMAIL`, `JIRA_API_TOKEN`), how to
  invoke `scripts/create-branch.sh`, and what to report back (branch created +
  base). Mentions `--dry-run` for previewing the name.

## Component: `agents/jira-brancher.md`

- Subagent definition. Tools: `Bash`, `Read`.
- Prompt: given a Jira URL, invoke the skill's script, handle errors, and report
  the resulting branch. All logic stays in the script; the agent is thin.

## Error handling

Distinct, actionable failures for: malformed URL, missing env vars, not a git
repo, Jira 401/403 (auth), Jira 404 (unknown key), network/curl failure, and a
dirty working tree (warn before switching branches).

## Testing

- A `--dry-run` plus `--summary`/`--type` overrides let us test URL parsing,
  type mapping, and slug computation without touching Jira or git.
- A small test script feeds known inputs and asserts the computed branch name,
  covering: normal story, bug, summary needing slug cleanup, long summary
  (cap at 50), empty/symbol-only summary, and a malformed URL (expect failure).
```
