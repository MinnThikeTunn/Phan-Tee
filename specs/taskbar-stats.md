# Taskbar stats

Real-time CPU, RAM, Disk, and Network monitoring in the Windows taskbar system tray with flyout charts. Replaces: HWMonitor, MenuBarStats.

## Brief

```markdown
# Stats

A lightweight taskbar tray monitor showing live system resource utilization with clean mini graphs.

## Main jobs
1. Display current CPU and Memory percentages as dynamic tray icons.
2. Click tray icon to view detailed flyout with per-core usage, disk I/O, and network speeds.
3. Configurable refresh interval (default 1 second, paused when flyout is closed).
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| System metrics | `System.Diagnostics.PerformanceCounter`, `Windows.System.Diagnostics` | Standard |
| System tray icon | Win32 `Shell_NotifyIconW` with dynamically rendered icon bitmap | Standard |
| Detailed flyout | WinUI 3 TeachingTip or flyout window | Standard |

## Stories

### US-101: Dynamic Tray Metric Icon
- [ ] Renders dynamic 16x16 CPU utilization badge in Windows notification area.
- [ ] Updates every 1000 ms with minimal overhead (< 0.5% CPU).

### US-102: System Resource Flyout
- [ ] Left-click reveals Acrylic flyout displaying CPU, RAM, Disk, and Network meters.
- [ ] Escape or clicking outside dismisses flyout cleanly.

## Gotchas
- `PerformanceCounter` initialization can take several hundred milliseconds; instantiate counters on a background worker thread during startup.
- Dynamic tray icons require recreating the HICON handle each tick; always call `DestroyIcon` on the preceding handle to avoid GDI handle leaks.

## Done when
System tray icon renders live percentage graphs and clicking reveals resource details without exceeding 1% CPU usage.
