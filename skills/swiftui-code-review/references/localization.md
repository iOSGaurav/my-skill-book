# Localization

**Category:** Localization

## Checks

- No hardcoded user-facing strings; use `LocalizedStringKey` / String Catalogs
  (`.xcstrings`). SwiftUI `Text("...")` takes a `LocalizedStringKey` — but string
  *interpolation* and `String(...)` values bypass localization.
- Correct pluralization (stringsdict / automatic grammar agreement) rather than
  manual `if count == 1`.
- Numbers, dates, currencies, and measurements formatted via `FormatStyle` /
  `Formatter`, not string concatenation.
- Layouts tolerate longer translations (no fixed widths that truncate; allow
  wrapping). Consider RTL where the app supports it.

## Examples

```swift
// ❌ Hardcoded + manual plural + manual formatting
Text("You have " + String(count) + " items")

// ✅ Localized, pluralized, formatted
Text("item_count \(count)")          // resolved via String Catalog plural rules
Text(price, format: .currency(code: "USD"))
```

## Severity hints

- User-facing hardcoded string on a shipped screen → Medium.
- Manual pluralization / formatting → Low/Medium.
- Layout that clips translated text → Medium.
