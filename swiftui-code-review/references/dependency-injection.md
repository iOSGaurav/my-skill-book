# Dependency injection

**Category:** Dependency injection

## Checks

- Dependencies are injected (via `init` or the SwiftUI `Environment`), not
  constructed inline inside views or view-models.
- Collaborators (networking, persistence, clock, analytics) sit behind protocols
  so they can be faked in tests.
- No hidden singletons reached through `.shared` deep inside logic that needs to
  be tested.
- Default arguments can supply production implementations while keeping seams
  open for tests.

## Examples

```swift
// ❌ Hard dependency on a singleton; not testable
final class FeedModel {
    func load() async { items = await APIClient.shared.fetch() }
}

// ✅ Injected protocol with a production default
protocol FeedService { func fetch() async -> [Item] }

final class FeedModel {
    private let service: FeedService
    init(service: FeedService = LiveFeedService()) { self.service = service }
    func load() async { items = await service.fetch() }
}
```

## Severity hints

- Untestable critical path due to hard singleton → Medium/High.
- Inline construction that merely reduces flexibility → Low.
