# Creator tools

On-screen HUD displaying keystrokes and mouse click halo animations for video tutorials, livestreams, and presentations. Replaces: Carnac, KeyCastr.

## Brief

```markdown
# KeyHUD

A transparent floating overlay that renders keys pressed and clicks as smooth visual badges.

## Main jobs
1. Display keystrokes (e.g. "Ctrl+Shift+P") in a smooth animated badge near the bottom corner.
2. Render expanding circle halos on mouse clicks.
3. Automatically hide passwords and sensitive input fields.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Keystroke hook | Win32 `SetWindowsHookEx(WH_KEYBOARD_LL)` | Standard |
| Mouse hook | Win32 `SetWindowsHookEx(WH_MOUSE_LL)` | Standard |
| Overlay window | Transparent click-through WinUI 3 Window with `WS_EX_TRANSPARENT \| WS_EX_LAYERED` | Standard |

## Stories

### US-101: Keystroke Overlay
- [ ] Displays pressed shortcut combinations in bottom-right corner.
- [ ] Badges fade out after 2 seconds of inactivity.

### US-102: Mouse Click Halos
- [ ] Left, right, and middle clicks render expanding color-coded ripples.
- [ ] Click events pass through cleanly without stealing focus.

## Gotchas
- `WH_KEYBOARD_LL` hook callbacks must return quickly (< 10 ms) or Windows will silently unhook the application. Offload UI rendering to a background queue.
- Use `WS_EX_TRANSPARENT | WS_EX_LAYERED | WS_EX_NOACTIVATE` so mouse clicks pass through completely to underlying applications.

## Done when
Keystrokes and mouse clicks animate smoothly without obstructing user interactions.
