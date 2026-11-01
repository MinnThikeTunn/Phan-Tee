---
name: build-and-verify
description: Build a WinUI 3 Windows app from the command line, install it, and check light and dark window snapshots of every page before calling a change done. Use when verifying a UI code change, when a build fails, or when running or testing the app.
allowed-tools: Bash(.\build.ps1*) Bash(tools/*) Read
---

# Build and verify

A change is done when four things are true:

1. `.\build.ps1` finishes with zero errors.
2. You inspected the light and dark snapshots of every page you touched.
3. The snapshots match what the user story or reference screenshot asks for.
4. The grid checks pass (`.\tools\grid-lint.ps1`).

Never report a UI change as done from code alone. XAML that compiles can still
render clipped text, empty lists, or unreadable contrast in dark mode.

## 1. Build

```powershell
.\build.ps1               # Release build, installs to %LOCALAPPDATA%\Programs\<App>\
.\build.ps1 -DebugBuild   # Faster build during tight iteration loops
.\build.ps1 -Open         # Restarts the running app with the new build
```

## 2. Snapshot

```powershell
.\tools\snap.ps1
```

It launches the app on an isolated temporary store (`PHANTEE_STORE`), cycles
through all pages in Light and Dark themes, saves high-DPI PNGs, and quits.

Inspect every PNG for common bugs:
- Clipped text or ellipsis on important labels.
- Uneven margins or off-grid alignment.
- Unwanted focus rings or selection boxes visible on window launch.

## 3. Check the Grid

```powershell
.\tools\grid-lint.ps1
.\tools\check-layout.ps1
```

Both must print `PASS`.

## Done when

`build.ps1` succeeded, snapshots in light and dark mode were verified, and
`grid-lint.ps1` passed.
