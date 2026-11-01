---
name: improve-architecture
description: Architecture check-in for a growing Windows C# codebase. Finds hot spots, proposes deeper modules, and refactors one step per commit with behavior proven unchanged. Use when at the end of a milestone, before a big feature, when a file passes 500 lines, or when the user asks to clean up code.
---

# Improve architecture

Features pile up, and an app that was easy to change gets hard to change.
A **check-in** catches that early: survey, propose, let the user pick, then
refactor in small steps that keep behavior proven identical via tests.

## When to run

- The end of a milestone (the `improve-loop` skill calls this skill there).
- Before a big feature: "What change to the code would make this feature easy?"
- A C# file over 500 lines, or a class with too many responsibilities.
- UI code directly performing raw SQL queries or file system mutations.
- When domain logic cannot be tested in `<AppName>CoreTests` without launching the UI.

## The target architecture

```text
Sources/
  <AppName>Core/         (Pure Domain, EF Core DbContext, models, services - NO XAML)
  <AppName>/             (Views, ViewModels, Window, Controls, Themes)
Tests/
  <AppName>CoreTests/    (xUnit tests running in milliseconds)
```

## 1. Survey

1. Find largest files:
   ```powershell
   Get-ChildItem -Path Sources -Recurse -Filter *.cs | Sort-Object Length -Descending | Select-Object -First 10 Name, Length
   ```
2. Identify shallow pass-through classes and merge or deepen them.
3. Move business rules from UI code-behinds into `<AppName>Core`.

## 2. Refactor in steps

- One small refactor per commit.
- Run `dotnet test` after every step to prove behavior is unchanged.

## Done when

Large files have been broken down, business logic is isolated in `<AppName>Core`, and `dotnet test` passes with zero regressions.
