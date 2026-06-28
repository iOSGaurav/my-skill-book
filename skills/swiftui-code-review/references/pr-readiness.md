# PR readiness

**Category:** PR readiness

## Checks

- The change is focused and scoped; no unrelated churn or drive-by refactors
  mixed in.
- No dead code, commented-out blocks, or leftover scaffolding.
- No leftover `print()` / debug logging / `dump()` / temporary feature flags.
- TODO / FIXME are tracked (ticket reference) or justified, not silent.
- Public API and non-obvious behavior are documented where warranted.
- No accidental file additions (build artifacts, `.DS_Store`, large binaries).
- Commit/PR message explains the why, not just the what.

## Examples

```swift
// ❌ Debug logging + untracked TODO left in
print("got here", user)        // remove
// TODO: handle pagination      // link a ticket or implement

// ✅ Clean
// (no debug prints; TODOs reference PROJ-1234)
```

## Severity hints

- Debug print / commented-out code shipped → Low/Medium.
- Large unrelated churn obscuring the change → Medium.
- Committed secret or large binary → see `security.md` / Blocker.
