# AOS (Android) subtask template

For an Android story, plan subtasks from this template **plus** items specific to
the acceptance criteria. Drop categories that genuinely don't apply.

## Standard categories

| Category | Typical subtask |
|---|---|
| UI | Build the Jetpack Compose screen(s) per the design / AC |
| State / logic | Add the ViewModel and UI state |
| Data / repository | Wire the repository / data source call |
| Unit tests | Cover the ViewModel logic and edge cases |
| Screenshot tests | Screenshot the screen states (loading/empty/loaded/error) |
| Accessibility | contentDescription, semantics, TalkBack, font scaling |
| Analytics / telemetry | Log the events the story requires |

## Planning notes

- One subtask per coherent unit of work; imperative, concise titles.
- Reflect explicit AC items as their own subtasks when sizeable.
- Include error/empty/loading handling when the story shows data.
- Add a localization subtask if the story introduces user-facing strings.
- Only include analytics/telemetry if the story (or its AC) calls for it.

## Example titles

```
Build login screen UI (Compose)
Add LoginViewModel + UI state
Wire auth repository
Handle loading / error states
Unit tests for LoginViewModel
Screenshot tests for login screen
Accessibility pass for login screen
```
