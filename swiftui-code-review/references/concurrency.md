# Concurrency

**Category:** Concurrency

## Checks

- UI state updates happen on the main actor (`@MainActor` / `await MainActor.run`).
- Use `async/await` and structured concurrency; avoid unstructured
  `Task.detached` unless there is a documented reason.
- Use `.task` / `.task(id:)` for lifecycle-bound async work so it is cancelled
  when the view disappears or the id changes.
- No blocking calls on the main thread; no `DispatchSemaphore.wait()` on main, no
  sync file/network I/O on main.
- Respect actor isolation; don't introduce data races on shared mutable state.
- Match a `Task`'s entry isolation to its synchronous prefix: if nothing before
  the first `await` needs the main actor, prefer `Task { @concurrent in ... }` and
  hop back with `await MainActor.run { ... }` only for the UI mutation.

## Examples

```swift
// ❌ Mutating UI state off the main actor
func refresh() async {
    let data = try await service.fetch()
    self.items = data            // may not be on main actor
}

// ✅ Hop back for the UI mutation
func refresh() async {
    let data = try await service.fetch()
    await MainActor.run { self.items = data }
}
```

## Severity hints

- UI mutation off main actor / data race → Blocker/High.
- Blocking main thread → Blocker.
- Missing `.task` cancellation → Medium.

See also `memory.md` for capture/cancellation of long-lived tasks.
