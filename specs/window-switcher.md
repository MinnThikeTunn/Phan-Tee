# Window switcher

Fast, searchable window switcher. Press Alt+Tab or a custom shortcut, type two letters, and jump directly to any open window. Replaces: Alt+Tab, WindowTop.

## Brief

```markdown
# Switch

A floating search panel that lists all open windows, filters as you type, and activates the selected window on Enter.

## Main jobs
1. Press Alt+` or a global hotkey to show the switcher instantly.
2. Filter open windows by title or process name with fuzzy search.
3. Press Enter to activate the window and bring it to the foreground.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Enumerate windows | Win32 `EnumWindows`, `IsWindowVisible`, `GetWindowText` | Standard |
| Filter alt-tab eligible | Check `WS_EX_TOOLWINDOW` and Cloaked DWM state | Standard |
| Activate window | Win32 `SetForegroundWindow`, `BringWindowToTop` | Standard |
| Floating panel | WinUI 3 Window with `WS_EX_TOPMOST` | Standard |

## Stories
- [ ] Global shortcut reveals centered switcher panel in under 40 ms.
- [ ] Typing filters the list in real-time.
- [ ] Pressing Enter switches focus and closes the switcher.
- [ ] Pressing Escape dismisses the panel.

## Gotchas
- `SetForegroundWindow` can be rejected by Windows if the switcher is not granted focus permission; use `AttachThreadInput` or `AllowSetForegroundWindow`.
- UWP apps hosted in `ApplicationFrameHost` require inspecting the child `CoreWindow` to retrieve the actual app icon and title.

## Done when
Switcher opens instantly, lists active windows with process icons, and activates the target window.
