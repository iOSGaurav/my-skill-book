# Reference Index

Quick navigation for the SwiftUI / iOS code review skill. Open the smallest
reference that matches the finding; cite its category in `findings.json`.

## Severity guide

- **Blocker** — must fix before merge (crashes, data loss, security holes, retain
  cycles, main-thread blocking, broken functionality).
- **High** — likely bug or significant quality/perf/accessibility problem.
- **Medium** — should fix; correctness-adjacent or maintainability.
- **Low** — minor improvement.
- **Nit** — style/preference, non-blocking.

## Categories

| File | Category | Use it for |
|---|---|---|
| `architecture.md` | Architecture & data flow | view/model boundaries, single source of truth |
| `state-management.md` | State management | `@State`/`@Binding`/`@StateObject`/`@ObservedObject`/`@Environment`, `@Observable` |
| `performance.md` | View decomposition & performance | `body` cost, `ForEach` identity, re-render scope |
| `concurrency.md` | Concurrency | `async/await`, `@MainActor`, `.task`, actor isolation |
| `memory.md` | Memory management | retain cycles, `[weak self]`, cancellation |
| `networking.md` | Networking & error handling | error/loading states, silent failures |
| `accessibility.md` | Accessibility | labels/traits, Dynamic Type, VoiceOver |
| `security.md` | Security | secrets, Keychain, ATS, logging |
| `testing.md` | Testing & snapshot coverage | unit/snapshot tests, determinism |
| `localization.md` | Localization | hardcoded strings, formatting, layout |
| `dependency-injection.md` | Dependency injection | injected deps, testable seams |
| `conventions.md` | Naming & conventions | API design guidelines, access control |
| `pr-readiness.md` | PR readiness | scope, dead code, debug prints, docs |

## Problem Router

- "Logic/state lives in the view" → `architecture.md`, `state-management.md`
- "View re-renders too much / janky scrolling" → `performance.md`
- "Crash or warning about the main actor / data race" → `concurrency.md`
- "Object never deallocates / leak" → `memory.md`
- "Errors are swallowed / no error UI" → `networking.md`
- "VoiceOver/Dynamic Type problems" → `accessibility.md`
- "Secret in code / sensitive data stored unsafely" → `security.md`
- "New code with no tests" → `testing.md`
- "Hardcoded user-facing string" → `localization.md`
- "Dependencies constructed inline / untestable" → `dependency-injection.md`
- "Naming / access-control issues" → `conventions.md`
- "Debug prints / unrelated churn / dead code" → `pr-readiness.md`
