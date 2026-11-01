# __APP_NAME__

A native Windows app in WinUI 3 and C#. It runs on this PC only, with a local
SQLite database and no server.

## Layout

- `Sources/__APP_NAME__/` the app. `App.xaml.cs` has the window, menus, and database location.
- `Sources/__APP_NAME__Core/` rules and data logic with no UI dependencies. Tests in `Tests/__APP_NAME__CoreTests/`.
- `__APP_NAME__.sln` the solution. Builds via `dotnet build` from PowerShell CLI without opening Visual Studio.
- `build.ps1` builds and installs `%LOCALAPPDATA%\Programs\__APP_NAME__\`.
- `Assets/Icon/AppIcon.svg` the app icon. `tools/make_icon.ps1` compiles it into multi-resolution `AppIcon.ico`.
- `docs/` the brief, screen index, and user stories.

## Build and check

- Build and run: `.\build.ps1`. Add `-Open` to launch or restart the app with the new build.
- Unit tests: `dotnet test Tests/__APP_NAME__CoreTests/`.
- Self-test (the app's real functions on a test store): `tools\selftest.ps1`. Exits 0 when every check passes.
- After every UI change, take snapshots with sample data and inspect them: `tools\snap.ps1`.
  It writes `C:\Temp\__APP_NAME__-shots\<page>-light.png` and `-dark.png` for every page, and `settings-<tab>-light.png` and `-dark.png` for every Settings tab, then quits.
- Never test against the real database in `%LOCALAPPDATA%\__APP_NAME__\`. Always use `PHANTEE_STORE` in temp.
- Then check the grid: `tools\grid-lint.ps1` and `tools\check-layout.ps1`. Both print PASS.
- A change is done when the build has no errors, the grid checks pass, and you looked at the light and dark snapshots.

## Design rules

- Use Windows 11 Fluent Design System 2 and system styles.
- Window backdrop uses Mica (`MicaBackdrop`) for the main window, and Acrylic for popups and dialogs.
- Typography: Segoe UI Variable. Icons: Segoe Fluent Icons (`FontIcon Glyph="\uE..."`).
- Spacing comes from `Space` in `UI/Grid.cs`, on a 4 px / 8 px grid. Mark custom pages and cards with `GridArea` and `GridProbe`.
- Corner radii: Windows 11 standard (8 px for buttons and cards, 4 px for small chips).
- Colors: system brushes (`TextFillColorPrimaryBrush`, `AccentFillColorDefaultBrush`). Never hard-coded hex colors in XAML.
- Every action has a keyboard shortcut and a CommandBar or MenuFlyout entry.

## Skills

The phan-tee plugin has a skill for each step: `win-design` (design rules),
`design-system` (accent and tokens), `layout-grid`, `ux-design`,
`csharp-winui`, `os-integrations`, `performance`, `build-and-verify`,
`test-win-app`, `app-icon`, `user-stories`, and `improve-loop`. Use them.

## Git

- Commit after each working change, with a message that says what the user can now do.
