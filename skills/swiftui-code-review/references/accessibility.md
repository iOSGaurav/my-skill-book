# Accessibility

**Category:** Accessibility

## Checks

- Meaningful `accessibilityLabel` / `accessibilityValue` / `accessibilityHint`;
  correct traits (`.isButton`, `.isHeader`, `.isSelected`).
- Icon-only / image buttons have labels (they are otherwise unusable in VoiceOver).
- Supports Dynamic Type: no fixed font sizes that clip; layouts scale (test at
  the largest accessibility sizes).
- Logical VoiceOver reading order; group related elements with
  `accessibilityElement(children:)`; hide decorative elements
  (`.accessibilityHidden(true)`).
- Sufficient color contrast; don't convey meaning by color alone.
- Interactive elements have adequate hit targets (≥ 44×44 pt).

## Examples

```swift
// ❌ Icon button with no label
Button(action: login) { Image(systemName: "person.circle") }

// ✅ Labeled
Button(action: login) { Image(systemName: "person.circle") }
    .accessibilityLabel("Log in")
```

## Severity hints

- Primary control invisible/unusable to VoiceOver → High.
- Missing label on a secondary control → Medium.
- Minor trait/hint omission → Low/Nit.
