# Design: `jira-subtasks` skill + agent

**Date:** 2026-06-28
**Status:** Approved

## Goal

Given a Jira story URL, plan the implementation subtasks from the story's
description and acceptance criteria — tailored to the platform (iOS or AOS) —
and emit them in a copyable format the user can paste into the Jira story.

Deliverables: a **skill** (`jira-subtasks`) backed by a deterministic fetch
script, plus a thin **agent** (`jira-subtasker`).

## Decisions (from brainstorming)

- **Input:** Jira story URL, fetched via the Jira REST API (reuses
  `JIRA_EMAIL` / `JIRA_API_TOKEN`).
- **Platform:** inferred from the story (labels / components / text); if
  ambiguous, ask the user. One platform per run.
- **Breakdown:** an opinionated per-platform template PLUS subtasks specific to
  this story's acceptance criteria.
- **Output:** a `[Platform] KEY — Subtasks` header, a Titles list (one per line
  for Jira quick-add), then a numbered Details section (description per subtask).

## Split: LLM + script

- **Script** (`fetch-story.sh`): deterministic fetch — parse URL, call the API,
  emit a clean text bundle (summary, type, labels, components, description,
  acceptance criteria, platform hint).
- **Claude** (the skill): reads the bundle, determines platform, applies the
  template + AC-specific planning, and formats the output. Subtask *content* is
  LLM-generated.

## Repo structure

```
jira-subtasks/
  SKILL.md
  agent.md
  scripts/fetch-story.sh
  tests/test.sh
```

## Component: `scripts/fetch-story.sh`

**Usage:** `fetch-story.sh <jira-url>` or `fetch-story.sh --from-file <json>`

1. Parse base host + issue key from the URL (same logic as jira-branch:
   `/browse/KEY` and `selectedIssue=KEY`). Error on a non-Jira URL.
2. Unless `--from-file`, require `JIRA_EMAIL` / `JIRA_API_TOKEN` and call:
   `GET $BASE/rest/api/3/issue/$KEY?expand=names,renderedFields&fields=summary,description,labels,components,issuetype`
   Map HTTP status to friendly errors (401/403 auth, 404 unknown key, other).
3. `python3` parses the JSON and prints a plain-text bundle:
   - `Summary:`, `Issue type:`, `Labels:`, `Components:`
   - `Description:` — HTML from `renderedFields.description` stripped to text.
   - `Acceptance Criteria:` — value of the field whose display name (from the
     `names` map) matches `/acceptance crit/i`, HTML-stripped. Omitted if not
     found. This avoids hardcoding an instance-specific custom-field id.
   - `Platform hint:` — `iOS`, `AOS/Android`, `both`, or `unknown`, derived by
     scanning labels, components, and summary for `ios` / `android` / `aos`.
4. `--from-file <json>` reads a saved API response instead of calling the
   network — used by the tests.

## Component: `skills/jira-subtasks/SKILL.md` (`SKILL.md`)

- Frontmatter `name: jira-subtasks`; `description:` triggers on "create/plan
  Jira subtasks", "break this story into subtasks".
- Body:
  1. Run `scripts/fetch-story.sh <url>`.
  2. Determine platform from the hint; if `unknown`/`both`, ask the user which
     platform to plan for.
  3. Plan subtasks = per-platform template + AC-specific items:
     - **iOS:** SwiftUI view; TCA reducer / ViewModel state; data/networking;
       unit tests; snapshot tests; accessibility; analytics/telemetry.
     - **AOS:** Compose UI; ViewModel/state; data/repository; unit tests;
       screenshot tests; accessibility; analytics/telemetry.
     Drop template items that genuinely don't apply; add items the AC requires.
  4. Output the agreed format: `[Platform] KEY — Subtasks` header, `--- Titles
     (copy for quick-add) ---` list (one summary per line), then `--- Details
     ---` numbered list with a 1–3 line description per subtask.

## Component: `agents/jira-subtasker.md` (`agent.md`)

- Subagent. Tools: `Bash`, `Read`.
- Prompt: fetch the story via the script, plan subtasks per platform, emit the
  copyable output. If the platform is ambiguous, report that it needs the user
  to specify rather than guessing. Does not write to Jira.

## Error handling

Clear, actionable failures for: malformed URL, missing env vars, Jira
401/403/404, network failure. Missing acceptance-criteria field is not an error
(the section is simply omitted, and planning proceeds from the description).

## Testing

`--from-file` + JSON fixtures make extraction testable offline:
- iOS fixture (label `iOS`, an "Acceptance Criteria" custom field): assert the
  bundle reports `Platform hint: iOS`, includes `Acceptance Criteria:`, and
  includes description text with HTML stripped.
- Android fixture (component `Android`): assert `Platform hint:` reports
  AOS/Android.
- Malformed URL: expect non-zero exit.
