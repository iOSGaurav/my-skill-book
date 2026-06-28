# my-skill-book

A collection of Claude Code skills and agents for a Jira-based git workflow.
Each feature lives in its own folder containing the skill (`SKILL.md`), the
agent (`agent.md`), the worker script, and tests.

```
jira-branch/    Create a git branch from a Jira ticket URL
jira-commit/    Commit changes with the branch's Jira ID as a message prefix
```

A typical flow: create a branch from a Jira ticket, make changes, then commit —
the Jira ID flows automatically from the branch name into every commit message.

## Prerequisites

- `git`, `bash`, `curl`, and `python3` available on PATH.
- For `jira-branch`, a Jira Cloud API token exported as environment variables:
  ```bash
  export JIRA_EMAIL="you@company.com"
  export JIRA_API_TOKEN="…"   # https://id.atlassian.com/manage-profile/security/api-tokens
  ```

---

## jira-branch

Create and check out a git branch named from a Jira ticket. Fetches the ticket
summary and issue type from the Jira REST API and builds the branch name.

**Branch format:** `<prefix>/<KEY>-<slug>`
- `prefix` = `bugfix` when the issue type is **Bug**, otherwise `feature`
- `slug` = lowercased summary, non-alphanumerics → `-`, capped at 50 chars
- Example: `feature/PROJ-123-add-login-button`

### Usage

```bash
jira-branch/scripts/create-branch.sh "https://yourco.atlassian.net/browse/PROJ-123"
```

Options:

| Option | Description |
| --- | --- |
| `--base <branch>` | Base off a specific branch (default: detected `origin/HEAD`, else `main`) |
| `--dry-run` | Print the computed branch name and base; make no changes |
| `--summary <text> --type <type>` | Skip the Jira fetch and supply details manually |

What it does: parse URL → fetch summary + type → compute name → fetch the base
branch → create and check out the new branch from it. If the branch already
exists, it is checked out instead.

---

## jira-commit

Generate a plain-English commit message from the current changes and commit it
with the Jira ID (taken from the current branch name) as a prefix. **Not**
conventional-commit style.

**Message format:** `KEY: <subject>` — e.g. `PROJ-123: add login button to header`
(the key is read from a branch like `feature/PROJ-123-add-login`).

### Usage

```bash
# review what will be committed
git add -A && git diff --staged

# commit (the script derives the Jira key from the branch and prepends it)
jira-commit/scripts/commit.sh "add login button to header"
# -> committed: PROJ-123: add login button to header
```

Options:

| Option | Description |
| --- | --- |
| `--print` | Print `KEY: <subject>` without committing (preview) |
| `--no-stage` | Commit only what is already staged (skip `git add -A`) |

By default the script stages all changes (`git add -A`) and then commits.

---

## Using with Claude Code

Each folder's `SKILL.md` and `agent.md` instruct Claude how to run the workflow.
You can describe the task in natural language (e.g. "create a branch for this
Jira ticket" / "commit these changes") and Claude follows the skill, or you can
run the scripts directly as shown above.

> Note: this repo uses a feature-grouped layout (skill + agent together per
> folder), which is not Claude Code's auto-discoverable plugin format. To make
> the skills/agents auto-discoverable, expose them via `skills/` + `agents/`
> top-level dirs and a `.claude-plugin/plugin.json` manifest.

## Tests

```bash
bash jira-branch/tests/test.sh
bash jira-commit/tests/test.sh
```

Both suites run offline (no Jira, no network) using dry-run / print modes and a
throwaway git repo.
