# Networking & error handling

**Category:** Networking & error handling

## Checks

- No silent failures: errors are handled, surfaced to the user, or logged
  meaningfully — never swallowed.
- Avoid `try?` where the failure is actionable; prefer typed, meaningful errors.
- Async UI exposes loading, empty, and error states — not just the happy path.
- No networking in `View.body`; trigger via `.task` or the model.
- Time-outs, retries, and cancellation are considered for user-initiated calls.
- Decoding failures are handled distinctly from transport failures where it helps
  the user or debugging.

## Examples

```swift
// ❌ Error swallowed; no user feedback
func load() async {
    items = (try? await service.fetch()) ?? []
}

// ✅ Explicit states
enum LoadState { case loading, loaded([Item]), failed(String) }

func load() async {
    state = .loading
    do { state = .loaded(try await service.fetch()) }
    catch { state = .failed(error.localizedDescription) }
}
```

## Severity hints

- Swallowed error that hides a real failure path → High.
- Missing error/loading UI on a primary flow → High/Medium.
- Missing timeout on a minor call → Low.

See `silent-failure` reasoning: a `catch {}` that does nothing is a finding.
