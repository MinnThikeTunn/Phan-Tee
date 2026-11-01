---
name: test-win-app
description: Test a Windows app at three levels, from xUnit unit tests and an in-app self-test to an agent debug bridge and keyboard accelerator audits. Use when adding logic, fixing a bug, or before a milestone release.
---

# Test a Windows app

Three levels, cheapest first:

| Level | Proves | Speed |
| --- | --- | --- |
| Unit tests (xUnit) | Domain rules, parsers, calculations | < 1 second |
| Self-test (`--selftest`) | The app's real database functions on a temp store | 1-2 seconds |
| Visual snapshots (`tools\snap.ps1`) | XAML rendering, layout, themes | 3-5 seconds |

## 1. Unit Tests

Domain logic lives in `<AppName>Core` with zero UI dependencies:

```powershell
dotnet test Tests/<AppName>CoreTests/
```

- Tests run in milliseconds without launching any window.
- Write unit tests for title sanitization, parsing, validation, and calculations.

## 2. In-App Self-Test

Run actual database operations on a fresh isolated store in TEMP:

```powershell
.\tools\selftest.ps1
# PASS insert item
# PASS query item
# PASS star item
# PASS complete item
# PASS delete item
# PASS all self-test checks passed
```

Always exits 0 when all checks pass.

## Done when

`dotnet test` passes with 0 failures and `tools\selftest.ps1` exits 0.
