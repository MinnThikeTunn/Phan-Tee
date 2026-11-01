# Dev toolkit

Offline developer Swiss Army knife: JSON formatter and validator, Base64 encoder/decoder, RegEx tester, JWT inspector, and hash generator. Replaces: DevToys, CyberChef.

## Brief

```markdown
# DevKit

An instant, offline toolbox for common developer data transformations.

## Main jobs
1. Format, minify, and validate JSON with syntax highlighting.
2. Encode and decode Base64 strings and files.
3. Test regular expressions against sample text in real time.
4. Decode JWT tokens and inspect headers and claims without leaking secrets online.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| JSON handling | `System.Text.Json` | Standard |
| Base64 | `System.Convert.ToBase64String` | Standard |
| RegEx matching | `System.Text.RegularExpressions.Regex` | Standard |
| Offline security | 100% offline, zero network requests | Standard |

## Stories

### US-101: JSON Formatter & Minifier
- [ ] Formats unformatted JSON with customizable 2-space indentation.
- [ ] Displays clear syntax error badges on invalid inputs.

### US-102: JWT Inspector & Base64 Decoder
- [ ] Decodes JWT header and payload without verifying or transmitting secrets.
- [ ] Converts Base64 to UTF-8 text and binary previews.

## Gotchas
- Large JSON payloads (> 10 MB) can cause UI stutter; run formatting on `Task.Run` and stream results into the text editor.
- Set strict execution timeouts on Regex operations (`RegexOptions.NonBacktracking` or timeout) to prevent catastrophic backtracking.

## Done when
All conversion tools process inputs in under 10 ms with instant copy buttons.
