---
name: csharp-winui
description: C# 13 and WinUI 3 code rules for native Windows apps, including async/await, CommunityToolkit.Mvvm, EF Core SQLite, DispatcherQueue, and compiler error fixes. Use when writing, reviewing, or debugging C# and XAML in a Windows app.
---

# C# and WinUI 3

The code is right when it compiles with zero warnings, unit tests pass,
and the app does what the user story says.

## Concurrency & UI Thread

In WinUI 3, all UI elements must be touched on the UI thread only. Background
work uses async/await and hops back when updating models or views.

| Work | Put it in |
| --- | --- |
| UI state, view models, XAML bindings | Main UI thread |
| I/O, database queries, file reading, HTTP | `await Task.Run(...)` or `async` EF Core methods |
| Background timer or worker updating UI | Hop back with `dispatcherQueue.TryEnqueue(() => { ... })` |

- Never block the UI thread with `.Result` or `.Wait()`. Always use `await`.
- Use `CancellationToken` for operations that can be cancelled when navigation changes.
- Handle exceptions inside background tasks to prevent unhandled app termination.

## MVVM State with CommunityToolkit.Mvvm

- Use `[ObservableObject]` on view models.
- Use `[ObservableProperty]` to auto-generate `INotifyPropertyChanged` properties:
  ```csharp
  [ObservableProperty]
  private string _title = string.Empty;
  ```
- Use `[RelayCommand]` on methods to create commands bound in XAML.
- Bind in XAML with `{x:Bind ViewModel.Property, Mode=OneWay}` or `TwoWay`.

## Entity Framework Core with SQLite

- Models use stable `Guid` primary keys (`public Guid Id { get; set; } = Guid.NewGuid();`).
- Database configuration reads `PHANTEE_STORE` or `APP_STORE` for isolated test runs.
- Always enable Write-Ahead Logging (`PRAGMA journal_mode=WAL;`) for responsive concurrent reads.
- Wrap modifications in `using var db = new AppDbContext(); db.SaveChanges();`.

## Keyboard Accelerators & Focus

- Add `KeyboardAccelerator` to buttons and menu items:
  ```xml
  <AppBarButton Icon="Add" Label="New Item">
      <AppBarButton.KeyboardAccelerators>
          <KeyboardAccelerator Key="N" Modifiers="Control" />
      </AppBarButton.KeyboardAccelerators>
  </AppBarButton>
  ```
- Windows open calm: suppress aggressive auto-focusing on startup so no unintended focus ring appears.

## Done when

`dotnet build` completes with 0 errors and 0 warnings, and unit tests pass.
