# Branch naming

How `create-branch.sh` builds the branch name. (This logic lives in the script;
this file documents it.)

## Format

```
<prefix>/<KEY>-<slug>
```

- **prefix** — from the Jira issue type:
  | Issue type | Prefix |
  |---|---|
  | Bug | `bugfix` |
  | everything else (Story, Task, Epic, …) | `feature` |
- **KEY** — the Jira issue key, upper-cased (e.g. `PROJ-123`).
- **slug** — from the summary: lowercased, every run of non-alphanumeric
  characters collapsed to `-`, leading/trailing `-` trimmed, capped at 50
  characters (no trailing `-` after the cap).

If the slug is empty after sanitizing (symbol-only summary), the branch is just
`<prefix>/<KEY>`.

## Examples

| Issue type | Key | Summary | Branch |
|---|---|---|---|
| Story | PROJ-123 | "Add login button" | `feature/PROJ-123-add-login-button` |
| Bug | PROJ-456 | "Fix crash on startup" | `bugfix/PROJ-456-fix-crash-on-startup` |
| Task | ABC-7 | "Clean Up: this MESS!!" | `feature/ABC-7-clean-up-this-mess` |
| Task | SYM-9 | "!!!@@@" | `feature/SYM-9` |

## Base branch

The new branch is created from the base branch, resolved in this order:
`--base <branch>` → detected `origin/HEAD` → `main`. The base is fetched before
branching so it is up to date.
