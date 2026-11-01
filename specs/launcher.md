# Quick Launcher

Floating command palette and app launcher. Press Alt+Space, type an app name, command, or file, and hit Enter. Replaces: PowerToys Run, Alfred, Raycast.

## Brief

```markdown
# Launch

A lightweight launcher that finds apps, settings, and files with instant keyboard response.

## Main jobs
1. Press Alt+Space to toggle a floating input panel.
2. Search installed applications (Start Menu, Program Files) and run them.
3. Quick calculations (e.g. "45 * 12") and web searches.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Global hotkey | Win32 `RegisterHotKey(MOD_ALT, VK_SPACE)` | Standard |
| Floating panel | WinUI 3 Window with Mica Alt and `WS_EX_TOOLWINDOW` | Standard |
| Installed apps index | Search `%APPDATA%\Microsoft\Windows\Start Menu\Programs` and `C:\ProgramData\...` | Standard |
| Process launch | `Process.Start(new ProcessStartInfo { UseShellExecute = true, FileName = path })` | Standard |

## Stories

### US-101: Floating Alt+Space Activation
- [ ] Alt+Space reveals the floating search bar centered on active monitor.
- [ ] Panel dismisses immediately on Escape or loss of focus.

### US-102: Search & Execute
- [ ] Queries installed shortcuts and displays results in < 30 ms.
- [ ] Enter executes the selected application or command.

## Gotchas
- Alt+Space is the system default shortcut for the window system menu; registering it globally requires unhooking or overriding `WM_SYSCOMMAND`.
- To avoid stealing focus unnecessarily during appearance, initialize window styles with `WS_EX_NOACTIVATE` until activated.

## Done when
Panel opens in under 40 ms on Alt+Space, searches applications accurately, and launches selections.
