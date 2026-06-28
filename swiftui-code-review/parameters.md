# SwiftUI / iOS Code Review Parameters

The rubric for `swiftui-code-review`. Each finding must cite one of these
**categories**. Use the listed checks as prompts — report only real, actionable
issues, not every theoretical concern.

Severity guide:
- **Blocker** — must fix before merge (crashes, data loss, security holes, retain
  cycles, main-thread blocking, broken functionality).
- **High** — likely bug or significant quality/perf/accessibility problem.
- **Medium** — should fix; correctness-adjacent or maintainability.
- **Low** — minor improvement.
- **Nit** — style/preference, non-blocking.

---

## Architecture & data flow
- Clear separation: views render, models/view-models hold logic and state.
- Single source of truth; no duplicated/derived state that can drift.
- No business logic, networking, or persistence inside `View` types.
- Dependencies flow inward; views depend on abstractions, not concretions.

## State management
- `@State` only for view-local, value-type, private state.
- `@StateObject` for objects the view **owns** (created once); `@ObservedObject`
  only for objects **injected** from outside (never created in `body`).
- `@Binding` for two-way value passing; not used to smuggle ownership.
- `@Environment` / `@EnvironmentObject` for cross-cutting dependencies; ensure
  the value is actually provided upstream (avoid runtime crashes).
- Prefer the Observation framework (`@Observable`) where the project uses it; use
  consistently.
- No mutation of state during `body` evaluation.

## View decomposition & performance
- Break large `body` into small, focused subviews/computed properties.
- Keep expensive work (formatting, sorting, filtering) out of `body`; compute in
  the model or cache it.
- Stable, unique identities in `ForEach` (`id:`); avoid index-as-id for mutable
  collections.
- Avoid `AnyView` where a concrete type or `@ViewBuilder` works.
- Minimize observed-object granularity so unrelated changes don't re-render.

## Concurrency
- UI state updates on the main actor (`@MainActor` / `MainActor.run`).
- Use `async/await` and structured concurrency; avoid unstructured detached
  tasks unless justified.
- Use `.task(id:)` for lifecycle-bound async work; cancel on disappear.
- No blocking calls on the main thread; no `DispatchSemaphore` waits on main.
- Respect actor isolation; avoid data races on shared mutable state.

## Memory management
- `[weak self]` in escaping closures / long-lived `Task`s that capture `self`.
- No reference cycles between view-models, coordinators, and closures.
- Cancel subscriptions / tasks / observers on teardown.

## Networking & error handling
- No silent failures: errors are handled, surfaced, or logged meaningfully.
- Typed, meaningful errors; no `try?` that swallows actionable failures.
- User-visible error and loading states for async UI.
- No networking in `View.body`; trigger via `.task`/model.

## Accessibility
- Meaningful `accessibilityLabel` / `value` / `hint`; correct traits.
- Supports Dynamic Type (no fixed font sizes that clip; scalable layouts).
- Logical VoiceOver order; decorative elements hidden from a11y.
- Sufficient color contrast; don't rely on color alone.
- Adequate hit targets (≥44pt) for interactive elements.

## Security
- No hardcoded secrets, API keys, or tokens.
- Sensitive data in Keychain, not `UserDefaults`.
- No sensitive data in logs; respect ATS (no arbitrary HTTP exceptions).
- Validate/escape external input used in URLs, web views, or queries.

## Testing & snapshot coverage
- Unit tests for new logic and view-model behavior, including edge cases.
- Snapshot/UI tests for new or changed views (states: loading/empty/error).
- Tests are deterministic (no real network/time/randomness).

## Localization
- No hardcoded user-facing strings; use `LocalizedStringKey` / string catalogs.
- Correct pluralization and number/date formatting via `Formatter`/format style.
- Layouts tolerate longer translated strings (no truncation/overlap).

## Dependency injection
- Dependencies injected (init/environment), not constructed inline in views.
- Testable seams (protocols) for networking, persistence, clock, etc.

## Naming & conventions
- Follows Swift API Design Guidelines (clarity, no redundant words).
- Consistent with surrounding codebase patterns and file organization.
- Access control is as restrictive as practical (`private`/`fileprivate`).

## PR readiness
- Change is focused and scoped; no unrelated churn.
- No dead code, commented-out blocks, or leftover `print()`/debug logging.
- TODOs are tracked/justified; public API documented where warranted.
