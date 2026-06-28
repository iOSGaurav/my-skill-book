# Security

**Category:** Security

## Checks

- No hardcoded secrets, API keys, tokens, or credentials in source.
- Sensitive data (tokens, passwords, PII) stored in the Keychain, not
  `UserDefaults` or plist.
- No sensitive data in logs / `print` / analytics events.
- Respect App Transport Security; no blanket `NSAllowsArbitraryLoads`.
- Validate / escape external input used in URLs, `WKWebView`, SQL, or shell.
- Pasteboard, screenshots, and backups don't leak sensitive content where it
  matters (e.g. `.privacySensitive()` for sensitive views).

## Examples

```swift
// ❌ Secret in source + token in UserDefaults
let apiKey = "sk_live_abc123"
UserDefaults.standard.set(authToken, forKey: "token")

// ✅ Secret injected/config; token in Keychain
let apiKey = config.apiKey
try keychain.set(authToken, for: .authToken)
```

## Severity hints

- Hardcoded live secret / token in plaintext storage → Blocker.
- ATS exception without justification → High.
- Sensitive value in a debug log → Medium/High.
