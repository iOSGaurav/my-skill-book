# Memory management

**Category:** Memory management

## Checks

- `[weak self]` in escaping closures and long-lived `Task`s that capture `self`
  (especially in view-models, coordinators, Combine sinks, notification
  observers).
- No reference cycles between view-models, coordinators, and their closures.
- Cancel subscriptions / tasks / observers on teardown; store `Task` handles when
  they must be cancellable.
- Watch for closures stored on `self` that also capture `self`.

## Examples

```swift
// ❌ Strong capture in a stored, long-lived Task → retain cycle
final class FeedModel {
    var task: Task<Void, Never>?
    func start() {
        task = Task {
            for await item in stream { self.append(item) }   // retains self
        }
    }
}

// ✅ Weak capture + cancellation
final class FeedModel {
    private var task: Task<Void, Never>?
    func start() {
        task = Task { [weak self] in
            for await item in stream { self?.append(item) }
        }
    }
    deinit { task?.cancel() }
}
```

## Severity hints

- Retain cycle on a long-lived object → Blocker/High.
- Missing cancellation that leaks a short-lived task → Medium.
