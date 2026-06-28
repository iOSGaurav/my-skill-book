# Naming & conventions

**Category:** Naming & conventions

## Checks

- Follows the Swift API Design Guidelines: clarity at the call site, no redundant
  words, methods read as phrases, booleans read as assertions (`isEnabled`).
- Consistent with the surrounding codebase (file organization, view/model
  naming, folder structure).
- Access control is as restrictive as practical (`private` / `fileprivate` by
  default; `public`/`open` only when needed).
- Types and members are named for their role, not their type (`loginButton`, not
  `v` or `button1`).
- Avoids force-unwraps (`!`) and force-casts (`as!`) outside of genuinely
  invariant cases.

## Examples

```swift
// ❌
let v = Button(...)
func process(d: Data, b: Bool) { ... }

// ✅
let loginButton = Button(...)
func process(_ data: Data, animated: Bool) { ... }
```

## Severity hints

- Force-unwrap that can crash on real input → High/Blocker.
- Unclear public API naming → Medium.
- Local naming nit → Nit.
