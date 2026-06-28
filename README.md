# my-skill-book

A Claude Code plugin: a library of skills for a Jira + iOS/Android workflow.
Every skill lives under `skills/<name>/`.

```
skills/
  jira-branch/          Create a git branch from a Jira ticket URL
  jira-commit/          Commit changes with the branch's Jira ID as a message prefix
  jira-subtasks/        Plan platform-aware subtasks for a Jira story (copyable output)
  swiftui-code-review/  Review SwiftUI/iOS changes; inline PR comments or HTML/MD report
  swift-expert/         iOS / Swift implementation guidance (imported)
  kotlin-specialist/    Android / Kotlin implementation guidance (imported)
  …                     plus ~100 imported iOS/Swift framework skills
                        (swiftui-navigation/, swiftdata/, storekit/, widgetkit/, …)
```

A typical flow: create a branch from a Jira ticket, make changes, then commit —
the Jira ID flows automatically from the branch name into every commit message.

### Structure

The four home-grown skills (`jira-*`, `swiftui-code-review`) follow this layout,
modeled on
[AvdLee/Swift-Concurrency-Agent-Skill](https://github.com/AvdLee/Swift-Concurrency-Agent-Skill):

```
skills/<skill>/
  SKILL.md           # Fast Path → routing → guardrails → reference router → checklist
  agent.md           # companion subagent
  references/         # modular reference docs + _index.md
  scripts/            # deterministic worker(s)
  tests/              # offline tests
```

Imported skills are `SKILL.md` + `references/` only. The repo is packaged as an
installable Claude Code plugin via
[`.claude-plugin/plugin.json`](.claude-plugin/plugin.json) and
[`.claude-plugin/marketplace.json`](.claude-plugin/marketplace.json); all skills
are registered there under `./skills/<name>`.

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
skills/jira-branch/scripts/create-branch.sh "https://yourco.atlassian.net/browse/PROJ-123"
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
skills/jira-commit/scripts/commit.sh "add login button to header"
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
skills/jira-subtasks/scripts/fetch-story.sh "https://yourco.atlassian.net/browse/PROJ-123"
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

## swiftui-code-review

Review SwiftUI / iOS changes against a comprehensive parameter checklist
(state, performance, concurrency, memory, accessibility, security, testing,
localization, DI, conventions, PR readiness). The rubric is split into modular
files under
[`swiftui-code-review/references/`](skills/swiftui-code-review/references/_index.md),
one per category.

Input can be a **GitHub PR URL**, a **branch**, or the **current working diff**.
For a PR URL the review is posted as inline PR comments; otherwise an HTML report
(Markdown optional) is generated with the same findings.

Claude reads the diff, applies the rubric, and produces a `findings.json` array
(`path`, `line`, `severity`, `category`, `issue`, `suggestion`) which the scripts
turn into the chosen output.

### Usage

```bash
# 1. collect the diff to review
skills/swiftui-code-review/scripts/collect-diff.sh --pr "https://github.com/owner/repo/pull/123"
skills/swiftui-code-review/scripts/collect-diff.sh --branch feature/PROJ-1-x
skills/swiftui-code-review/scripts/collect-diff.sh            # current working diff

# 2a. PR URL -> post inline review comments (needs authenticated gh)
skills/swiftui-code-review/scripts/post-review.sh --pr "<url>" --findings findings.json \
  --event REQUEST_CHANGES          # add --print to preview the payload only

# 2b. branch / current diff -> report (HTML default, --md for Markdown)
skills/swiftui-code-review/scripts/render-report.sh --findings findings.json --out review.html
skills/swiftui-code-review/scripts/render-report.sh --findings findings.json --md --out review.md
```

Severity ∈ Blocker / High / Medium / Low / Nit; the verdict is **Request
changes** when any Blocker/High is present.

> Posting to a PR requires the [`gh`](https://cli.github.com) CLI, authenticated.
> The test suite exercises posting only via `--print` (no network).

---

## swift-expert / kotlin-specialist (imported)

iOS/Swift and Android/Kotlin implementation-guidance skills, imported from
[jeffallan/claude-skills](https://github.com/jeffallan/claude-skills) (MIT). They
are pure skill + `references/` (no scripts or tests), matching this repo's
structure.

- **`swift-expert/`** — SwiftUI, async/await concurrency, actors, protocol-oriented
  design, memory/performance, testing. References under
  [`swift-expert/references/`](skills/swift-expert/references/).
- **`kotlin-specialist/`** — coroutines/Flow, Jetpack Compose, Kotlin
  Multiplatform, Ktor, DSLs. References under
  [`kotlin-specialist/references/`](skills/kotlin-specialist/references/).

These complement the home-grown skills: use them for *writing* iOS/Android code,
and `swiftui-code-review` for *reviewing* it. Attribution and license text are in
[`THIRD_PARTY_LICENSES.md`](THIRD_PARTY_LICENSES.md); each imported `SKILL.md`
also keeps its original `license`/`author` frontmatter.

---

## iOS framework skills (imported from dpearson2699/swift-ios-skills)

84 focused iOS skills, one folder per Apple framework / topic — e.g.
`swiftui-navigation/`, `swiftui-animation/`, `swiftui-performance/`, `swiftdata/`,
`storekit/`, `healthkit/`, `cloudkit/`, `widgetkit/`, `mapkit/`, `coreml/`,
`push-notifications/`, `swift-concurrency/`, `swift-testing/`, and many more. Each
is a `SKILL.md` + `references/` (upstream `evals/` were not imported).

> **License:** these are under the **PolyForm Perimeter License 1.0.0**
> (Copyright © 2025 dpearson2699), *not* MIT. PolyForm Perimeter restricts use
> that competes with the licensor's product/service. The full license is in
> [`licenses/swift-ios-skills-LICENSE.txt`](licenses/swift-ios-skills-LICENSE.txt)
> and the required notice is in
> [`THIRD_PARTY_LICENSES.md`](THIRD_PARTY_LICENSES.md). Review the terms before
> redistributing this repository.

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
bash swiftui-code-review/tests/test.sh
```

Both suites run offline (no Jira, no network) using dry-run / print modes and a
throwaway git repo.
