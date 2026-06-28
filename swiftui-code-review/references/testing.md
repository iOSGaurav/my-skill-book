# Testing & snapshot coverage

**Category:** Testing & snapshot coverage

## Checks

- New logic and view-model behavior have unit tests, including edge cases
  (empty, error, boundary values).
- New or changed views have snapshot / UI tests covering key states
  (loading / empty / loaded / error).
- Tests are deterministic: no real network, wall-clock time, or randomness —
  inject clocks, use fakes/stubs, and fixed seeds.
- Async tests use modern waiting (`await fulfillment(of:)` / Swift Testing), not
  `sleep` or unavailable `wait`.
- Tests assert behavior, not implementation details that will churn.

## Examples

```swift
// ✅ Deterministic: injected service + clock, explicit states asserted
@Test func showsErrorWhenFetchFails() async {
    let model = FeedModel(service: FailingService(), clock: TestClock())
    await model.load()
    #expect(model.state == .failed)
}
```

## Severity hints

- New, non-trivial logic with zero tests → High/Medium.
- View change with no snapshot coverage → Medium.
- Flaky/non-deterministic test introduced → High.
