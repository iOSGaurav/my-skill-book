---
name: jira-subtasks
description: Use when the user wants to plan or create Jira subtasks for a story, or break a story into subtasks. Fetches a Jira story by URL, infers the platform (iOS or AOS/Android), and outputs a copyable list of implementation subtasks based on the description and acceptance criteria.
---

# Jira Subtasks

Plan implementation subtasks for a Jira story, tailored to the platform, and
output them in a format the user can copy directly into the story.

## Prerequisites

Jira Cloud API token, exported as environment variables:
- `JIRA_EMAIL` — your Atlassian account email
- `JIRA_API_TOKEN` — https://id.atlassian.com/manage-profile/security/api-tokens

## Workflow

1. **Fetch the story** with the helper script:
   ```bash
   scripts/fetch-story.sh "https://yourco.atlassian.net/browse/PROJ-123"
   ```
   It prints summary, issue type, labels, components, description, acceptance
   criteria (if present), and a `Platform hint:`.

2. **Determine the platform** from `Platform hint:`. If it is `unknown` or
   `both`, ask the user which platform to plan for (iOS or AOS). Plan one
   platform per run.

3. **Plan subtasks** = a per-platform standard template PLUS subtasks the
   acceptance criteria specifically require. Drop template items that genuinely
   don't apply to this story; add anything the AC needs.

   **iOS template categories:**
   - UI — SwiftUI view(s)
   - State / logic — TCA reducer or ViewModel
   - Data / networking
   - Unit tests
   - Snapshot tests
   - Accessibility
   - Analytics / telemetry

   **AOS (Android) template categories:**
   - UI — Jetpack Compose screen(s)
   - State / logic — ViewModel
   - Data / repository
   - Unit tests
   - Screenshot tests
   - Accessibility
   - Analytics / telemetry

4. **Output** in this exact copyable shape:

   ```
   [<Platform>] <KEY> — Subtasks

   --- Titles (copy for quick-add) ---
   <subtask title 1>
   <subtask title 2>
   ...

   --- Details ---
   1. <subtask title 1>
      <1–3 line description of the work, referencing the relevant AC>
   2. <subtask title 2>
      ...
   ```

   Titles are concise and imperative. Keep one subtask per line in the Titles
   block so the user can paste them straight into Jira's quick-add subtask field.

## Notes

- Base subtask scope on the actual description + acceptance criteria; do not
  invent requirements that aren't there.
- If acceptance criteria are missing, plan from the description and say so.
