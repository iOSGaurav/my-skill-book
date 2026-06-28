# iOS subtask template

For an iOS (SwiftUI / TCA / MVVM) story, plan subtasks from this template **plus**
items specific to the acceptance criteria. Drop categories that genuinely don't
apply (e.g. no networking for a pure UI tweak).

## Standard categories

| Category | Typical subtask |
|---|---|
| UI | Build the SwiftUI view(s) per the design / AC |
| State / logic | Add the TCA reducer (or ViewModel) and state |
| Data / networking | Wire the API client / repository call |
| Unit tests | Cover the reducer/view-model logic and edge cases |
| Snapshot tests | Snapshot the view states (loading/empty/loaded/error) |
| Accessibility | Labels, traits, Dynamic Type, VoiceOver order |
| Analytics / telemetry | Log the events the story requires |

## Planning notes

- One subtask per coherent unit of work; keep titles imperative and concise.
- Reflect explicit AC items as their own subtasks when they are sizeable.
- Include error/empty/loading handling when the story shows data.
- Add a localization subtask if the story introduces user-facing strings.
- Only include analytics/telemetry if the story (or its AC) calls for it.

## Example titles

```
Build login screen UI (SwiftUI)
Add LoginFeature reducer + state (TCA)
Wire auth API client
Handle loading / error states
Unit tests for LoginFeature
Snapshot tests for login screen
Accessibility pass for login screen
```
