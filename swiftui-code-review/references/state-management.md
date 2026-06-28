# State management

**Category:** State management

## Checks

- `@State` only for view-local, private, value-type state.
- `@StateObject` for reference objects the view **owns** (created once for the
  view's lifetime); `@ObservedObject` only for objects **injected** from outside.
  Never create an `@ObservedObject` in `body` — it is re-created on every render.
- `@Binding` for two-way value passing; not a backdoor for ownership.
- `@Environment` / `@EnvironmentObject` for cross-cutting dependencies; confirm
  the value is actually provided upstream (a missing `@EnvironmentObject` crashes
  at runtime).
- Prefer the Observation framework (`@Observable` + `@State`) where the project
  uses it; apply consistently rather than mixing paradigms ad hoc.
- No mutation of state during `body` evaluation.

## Examples

```swift
// ❌ Ownership via @ObservedObject created inline — recreated every render
struct CartView: View {
    @ObservedObject var model = CartModel()   // loses state on re-render
}

// ✅ View owns it
struct CartView: View {
    @StateObject private var model = CartModel()
}

// ✅ Injected from a parent that owns it
struct CartView: View {
    @ObservedObject var model: CartModel
}
```

## Severity hints

- `@ObservedObject`/`@StateObject` misuse causing state loss → High.
- Force-unwrapped/missing environment value → Blocker (crash) if reachable.
- Wrong wrapper but no functional impact → Low/Medium.
