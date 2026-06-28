# Third-party licenses

## Imports flattened into `skills/`

Imported on 2026-06-28 and flattened into `skills/<name>/` (kebab-cased; two
name-collisions dropped: incoming `swift-concurrency` and `swiftui-liquid-glass`
already existed). Heavy binary assets (images) were pruned.

| Source | License | Notes |
|---|---|---|
| [patrickserrano/skills](https://github.com/patrickserrano/skills) | **MIT** (text at `licenses/patrickserrano-skills-LICENSE`) | iOS/macOS skills; `github-issue-fix-flow` excluded |
| [qunwang6/swift-ios-ui](https://github.com/qunwang6/swift-ios-ui) | **No license file** ⚠️ | all-rights-reserved by default |
| [mosif16/codex-skills](https://github.com/mosif16/codex-skills) | **No license file** ⚠️ | all-rights-reserved by default; only iOS/Swift/mobile skills imported (Rust + general excluded) |
| [nonameplum/agent-skills](https://github.com/nonameplum/agent-skills) | **No license file** ⚠️ | all-rights-reserved by default; `functional-programming-developer` + `git-user` excluded |

> ⚠️ **License risk:** the three "no license file" sources grant no rights to
> copy, modify, or redistribute by default. Resolve their licensing (ask the
> authors / confirm terms) **before** redistributing this repository or pushing
> it publicly. `partme-ai/full-stack-skills` was reviewed and **not** imported —
> it has no skills in this format (docs/aggregator only).

## dpearson2699/swift-ios-skills

84 iOS skills (one folder per Apple framework/topic, e.g. `swiftui-navigation/`,
`swiftdata/`, `storekit/`, `healthkit/`, …) were imported from
[dpearson2699/swift-ios-skills](https://github.com/dpearson2699/swift-ios-skills).

**Required Notice:** Copyright (c) 2025 dpearson2699
(https://github.com/dpearson2699)

These skills are licensed under the **PolyForm Perimeter License 1.0.0**. The
full license text is preserved at
[`licenses/swift-ios-skills-LICENSE.txt`](licenses/swift-ios-skills-LICENSE.txt).
Each imported `SKILL.md` retains its original content. Only `SKILL.md` and
`references/` were imported; upstream `evals/` were not.

> Note: PolyForm Perimeter restricts use that competes with the licensor's
> product/service. Review the license before redistributing this repository.

## jeffallan/claude-skills

The following skills were imported from
[jeffallan/claude-skills](https://github.com/jeffallan/claude-skills) and are
used under the MIT License. Each imported `SKILL.md` also retains its original
`license` and `author` frontmatter.

- `swift-expert/` — iOS / Swift skill + references
- `kotlin-specialist/` — Android / Kotlin skill + references

```
MIT License

Copyright (c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
