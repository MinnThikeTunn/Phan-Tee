# Phan-Tee Specs

12 build plans for small native Windows apps, adapted to Windows 11, WinUI 3,
and Win32 APIs. Each spec contains a Brief, How it works, Stories, Gotchas,
and Done when criteria.

To build any app here, copy its file into an empty folder and ask your agent:

```text
Build the app in window-snapper.md with Phan-Tee.
```

## Catalog

| Spec | What it does | Replaces | System hooks |
| --- | --- | --- | --- |
| [window-snapper.md](window-snapper.md) | Snap front window to halves, thirds, or monitors | PowerToys FancyZones, Magnet | Win32 `SetWindowPos`, `RegisterHotKey` |
| [window-switcher.md](window-switcher.md) | Searchable Alt+Tab switcher with instant filter | Alt+Tab, WindowTop | Win32 `EnumWindows`, `SetForegroundWindow` |
| [launcher.md](launcher.md) | Alt+Space floating quick launcher | PowerToys Run, Alfred | Global hotkey, `WS_EX_NOACTIVATE` |
| [clipboard-history.md](clipboard-history.md) | Clipboard history with quick search and paste | Windows Clipboard (Win+V), Paste | `AddClipboardFormatListener`, `SendInput` |
| [taskbar-stats.md](taskbar-stats.md) | CPU, RAM, Disk, and Network stats in taskbar tray | HWMonitor, MenuBarStats | System tray `Shell_NotifyIcon`, PerformanceCounters |
| [screen-recorder.md](screen-recorder.md) | Record screen or window to MP4 with audio | OBS, Camtasia | `Windows.Graphics.Capture`, MediaComposition |
| [screenshots.md](screenshots.md) | Area screen capture with instant copy and annotation | Snipping Tool, CleanShot | WinRT screen capture, global hotkey |
| [text-snippets.md](text-snippets.md) | Text expansion macros typing into front app | TextExpander, AutoHotkey | Low-level keyboard hook, `SendInput` |
| [toolbox.md](toolbox.md) | Quick system toggles: keep awake, empty trash, audio | PowerToys Awake, AudioSwitcher | `SetThreadExecutionState`, CoreAudio |
| [creator-tools.md](creator-tools.md) | Keystroke HUD overlay and mouse click halos | Carnac, KeyCastr | Low-level keyboard/mouse hooks, transparent overlay |
| [dev-toolkit.md](dev-toolkit.md) | Developer Swiss Army knife: JSON, Base64, RegEx, JWT | DevToys, CyberChef | Offline local parsers |
| [color-picker.md](color-picker.md) | Screen color eyedropper magnifier and palette | PowerToys Color Picker | Win32 GDI `GetPixel`, magnifier popup |
