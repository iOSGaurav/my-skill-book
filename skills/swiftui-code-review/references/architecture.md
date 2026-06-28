# Architecture & data flow

**Category:** Architecture & data flow

## Checks

- Clear separation: views render; models / view-models hold logic and state.
- Single source of truth; no duplicated or derived state that can drift.
- No business logic, networking, or persistence inside `View` types.
- Dependencies flow inward; views depend on abstractions, not concretions.
- Navigation/routing state is owned outside individual leaf views.

## Why it matters

Logic embedded in views is hard to test, easy to duplicate, and re-runs on every
re-render. Keeping views thin makes behavior testable and rendering cheap.

## Examples

```swift
// ❌ Business logic + networking in the view
struct ProfileView: View {
    @State private var user: User?
    var body: some View {
        Text(user?.name ?? "")
            .task { user = try? await URLSession.shared.decode(User.self, from: url) }
    }
}

// ✅ View renders; the model owns the work and state
@Observable final class ProfileModel {
    private(set) var user: User?
    private let service: UserService
    init(service: UserService) { self.service = service }
    func load() async { user = await service.currentUser() }
}

struct ProfileView: View {
    @State private var model: ProfileModel
    var body: some View {
        Text(model.user?.name ?? "")
            .task { await model.load() }
    }
}
```

## Severity hints

- Networking/persistence in `body` → High/Blocker.
- Duplicated source of truth that can desync → High.
- Minor boundary smell → Low/Medium.
