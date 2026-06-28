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

## Fast Path

1. **Fetch the story:**
   ```bash
   scripts/fetch-story.sh "https://yourco.atlassian.net/browse/PROJ-123"
   ```
   Prints summary, issue type, labels, components, description, acceptance
   criteria (if present), and a `Platform hint:`.
2. **Determine the platform** from `Platform hint:`:
   - `iOS` → plan with `references/ios.md`.
   - `AOS/Android` → plan with `references/aos.md`.
   - `unknown` or `both` → **ask the user** which platform to plan for. Plan one
     platform per run.
3. **Plan subtasks** = the platform template + AC-specific items (drop template
   items that don't apply; add what the AC requires).
4. **Output** in the exact shape from `references/output-format.md`.

## Guardrails

- Base subtask scope on the actual description + acceptance criteria; do not
  invent requirements that aren't there.
- One subtask per coherent unit of work; concise imperative titles.
- If acceptance criteria are missing, plan from the description and say so.
- Plan a single platform per run; don't mix iOS and AOS subtasks in one output.

## Reference Router

See [`references/_index.md`](references/_index.md):

- `references/ios.md` — iOS (SwiftUI/TCA) subtask template
- `references/aos.md` — Android (Compose) subtask template
- `references/output-format.md` — the exact copyable output shape

## Verification Checklist

1. The story was fetched and the platform decided (asked the user if ambiguous).
2. Every template category was considered (included or consciously dropped).
3. Each acceptance-criterion of substance maps to at least one subtask.
4. Output matches `references/output-format.md`: header, Titles (one per line),
   numbered Details aligned 1:1 with the titles.
