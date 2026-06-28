# my-skill-book

A collection of Claude Code skills and agents for a Jira-based git workflow.
Each feature lives in its own folder containing the skill (`SKILL.md`), the
agent (`agent.md`), the worker script, and tests.

```
jira-branch/      Create a git branch from a Jira ticket URL
jira-commit/      Commit changes with the branch's Jira ID as a message prefix
jira-subtasks/    Plan platform-aware subtasks for a Jira story (copyable output)
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

## jira-subtasks

Plan the implementation subtasks for a Jira story from its description and
acceptance criteria, tailored to the platform (iOS or AOS/Android), and output
them in a copyable format you can paste into the story.

Needs `JIRA_EMAIL` / `JIRA_API_TOKEN` (same as `jira-branch`).

### Usage

The helper script fetches the story and prints a clean bundle (summary, type,
labels, components, description, acceptance criteria, and a platform hint):

```bash
jira-subtasks/scripts/fetch-story.sh "https://yourco.atlassian.net/browse/PROJ-123"
```

Then Claude (via the skill/agent) infers the platform, applies a per-platform
template plus AC-specific items, and produces the subtask output:

```
[iOS] PROJ-123 — Subtasks

--- Titles (copy for quick-add) ---
Build login button UI (SwiftUI)
Present login sheet on tap
Add VoiceOver support for login button
Unit tests for login entry point
Snapshot tests for header with login button

--- Details ---
1. Build login button UI (SwiftUI)
   Add a Login button to the header per AC; visible when logged out.
2. ...
```

The Titles block is one subtask per line so you can paste straight into Jira's
quick-add subtask field.

Options:

| Option | Description |
| --- | --- |
| `--from-file <json>` | Parse a saved API response instead of calling the network (used by tests) |

Platform is inferred from the story's labels/components/text; if it's ambiguous
or targets both, you'll be asked which platform to plan for.

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
bash jira-subtasks/tests/test.sh
```

Both suites run offline (no Jira, no network) using dry-run / print modes and a
throwaway git repo.
