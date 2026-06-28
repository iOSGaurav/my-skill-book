# Output format

Produce exactly this copyable shape so the user can paste subtasks into the Jira
story. The **Titles** block is one subtask per line (for Jira quick-add); the
**Details** block expands each with a short description.

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

## Rules

- `<Platform>` is `iOS` or `AOS` (the one you planned for).
- Titles are concise and imperative; keep exactly one per line in the Titles
  block (no numbering there).
- Details are numbered and align 1:1 with the Titles list, in the same order.
- Each detail description ties back to the description / acceptance criteria;
  don't invent requirements.
- If acceptance criteria were missing, plan from the description and note that.
