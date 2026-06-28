# View decomposition & performance

**Category:** View decomposition & performance

## Checks

- Break large `body` into small, focused subviews / computed properties.
- Keep expensive work (formatting, sorting, filtering, regex) out of `body`;
  compute in the model or cache it. `body` can run very frequently.
- Stable, unique identities in `ForEach` (`id:` or `Identifiable`); avoid using
  array index as id for mutable collections (causes wrong diffing/animations).
- Avoid `AnyView` where a concrete type or `@ViewBuilder` works (defeats the
  diffing optimizations).
- Minimize observation granularity so unrelated changes don't re-render a whole
  screen.
- Be wary of `GeometryReader` wrapping large subtrees and of work inside
  `onAppear` that should be `.task`.

## Examples

```swift
// ❌ Sorting on every body evaluation; index as identity
var body: some View {
    ForEach(Array(items.sorted().enumerated()), id: \.offset) { _, item in
        Row(item)
    }
}

// ✅ Pre-sorted in the model; stable identity
var body: some View {
    ForEach(model.sortedItems) { item in   // item: Identifiable
        Row(item)
    }
}
```

## Severity hints

- Heavy work in `body` on a hot path → High.
- Index-as-id on a mutable list → Medium/High (visual bugs).
- Unnecessary `AnyView` → Low/Nit.
