---
name: new-win-app
description: Create a native Windows WinUI 3 app from a working template (.NET, WinUI 3 unpackaged, EF Core SQLite, build script, icon script, snapshot mode, git), with no Visual Studio GUI. Use when the user wants to start a new Windows app or scaffold a Windows project.
argument-hint: "<AppName> <package-id> [parent-folder]"
allowed-tools: Bash(*/new-app.ps1 *) Bash(git *) Bash(dotnet *) Read Write Edit
---

# New Windows app

The template builds and runs as is. The first build proves the .NET toolchain
works before you write feature code.

## What the template is

A .NET solution with an unpackaged WinUI 3 executable target, a pure Core
class library, and an xUnit test project. An agent can read and edit every file.

```text
<AppName>/
  <AppName>.slnx         .NET 10 solution, unpackaged WinUI 3, zero MSIX hurdles
  Directory.Build.props  centralized compilation properties
  build.ps1              dotnet build -> %LOCALAPPDATA%\Programs\<AppName>\
  CLAUDE.md              build, check, and design rules for agents
  Sources/<AppName>/
    App.xaml / .cs       window lifecycle, settings, snapshot & selftest interceptors
    MainWindow.xaml / .cs Mica backdrop, custom TitleBar, NavigationView
    ContentView.xaml / .cs master-detail list, item editor, CommandBar
    Models.cs            observable UI models, sidebar enums
    SeedData.cs          PHANTEE_SEED=1 deterministic sample records
    SelfTest.cs          in-app functional self-test
    Snapshot.cs          PHANTEE_SNAPSHOT mode: PNG and layout file per page, light and dark
    UI/Theme.cs          Mica backdrops, theme controllers, accent tokens
    UI/Grid.cs           the 4 px spacing scale, layout probes, Space tokens
    UI/WindowBehavior.cs window sizing, centering, title bar extensions
  Sources/<AppName>Core/
    <AppName>Core.csproj pure .NET class library (zero UI dependencies)
    AppDbContext.cs      EF Core SQLite database context with WAL mode
    ItemTitle.cs         title sanitization and validation rules
    Models.cs            database entity models with Guid primary keys
  Tests/<AppName>CoreTests/
    ItemTitleTests.cs    instant xUnit unit tests
  tools/
    build.ps1            release/debug build and install
    snap.ps1             samples data, light and dark PNGs
    selftest.ps1         runs self-test against isolated store in TEMP
    grid-lint.ps1        flags spacing numbers off the 4 px grid
    check-layout.ps1     checks layout probe bounding boxes
    make_icon.ps1        Assets/Icon/AppIcon.svg -> AppIcon.ico
    icon_review.ps1      renders contact sheet of icon resolutions
```

## Steps

1. Check the toolchain:

   ```powershell
   dotnet --version           # .NET 9.0 or 10.0 or later
   ```

2. Pick the name (one UpperCamelCase word) and package id (reverse DNS). If
   `docs/BRIEF.md` exists, use its name.

3. Run the scaffolding script with the parent folder:

   ```powershell
   & "${PHANTEE_SKILL_DIR}\scripts\new-app.ps1" Tasks com.yourname.tasks ~/Developer
   ```

4. Build the app and open it:

   ```powershell
   cd ~/Developer/Tasks; .\build.ps1 -Open
   ```

5. Run the checks the template ships with:

   ```powershell
   dotnet test Tests/TasksCoreTests/        # Unit tests
   .\tools\selftest.ps1                     # PASS per check, exit 0
   .\tools\snap.ps1                         # sample data, light and dark PNGs
   .\tools\grid-lint.ps1                    # PASS grid-lint
   ```

6. If `docs/BRIEF.md` exists, rename `Item` to the brief's main type and the
   sidebar pages to the brief's pages. Features go through `improve-loop`,
   one story at a time. Build, snapshot, commit.

## Done when

The project built with `build.ps1`, unit tests and self-test passed with exit 0,
and snapshots were verified in both light and dark modes.
