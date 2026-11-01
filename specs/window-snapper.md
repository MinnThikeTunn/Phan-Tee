# Window snapper

Snap the front window to the left or right half, wide side, or full screen with a keyboard shortcut, and move it across displays. Replaces: PowerToys FancyZones, Magnet, Rectangle.

## Brief

```markdown
# Snap

A taskbar tray app that moves and resizes the frontmost window with keyboard shortcuts.

## Replaces
PowerToys FancyZones, Magnet

## Main jobs
1. Snap the front window to the left half, right half, or maximize with a shortcut.
2. Snap to wide sides (two-thirds) or move to the next display.
3. Customize shortcuts and window margins in Settings.

## Data
- Shortcuts: JSON configuration in %LOCALAPPDATA%\Snap\shortcuts.json.
- Window restore bounds: in-memory map of window handles to original RECT.

## Shape
System tray notification icon + Settings dialog. No Taskbar button when closed.

## System hooks
Global hotkeys (Win32 RegisterHotKey), SetWindowPos, Taskbar NotifyIcon.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Global shortcuts | Win32 `RegisterHotKey` | Standard |
| Active window | Win32 `GetForegroundWindow` | Standard |
| Move and resize | Win32 `SetWindowPos` | Standard |
| Screen work area | `System.Windows.Forms.Screen.FromHandle(hWnd).WorkingArea` | Standard |
| System tray | WinUI 3 Taskbar Tray (`Shell_NotifyIconW`) | Standard |

## Stories

### US-101: Snap Left and Right [snap] [self]
- [ ] Win+Alt+Left snaps front window to left 50% of the screen work area.
- [ ] Win+Alt+Right snaps front window to right 50% of the screen work area.
- [ ] Taskbar and multi-monitor boundaries are respected.

### US-102: Maximize and Restore [self]
- [ ] Win+Alt+Up maximizes or snaps to full work area.
- [ ] Win+Alt+Down restores the window to its position before snapping.

## Gotchas
- High DPI awareness: always use `DwmGetWindowAttribute(DWMWA_EXTENDED_FRAME_BOUNDS)` to avoid drop-shadow margin offsets.
- Windows with fixed minimum sizes (e.g. calculator) will clamp to their minimum dimensions.

## Done when
`dotnet build` succeeds, shortcuts snap windows accurately, and `tools\selftest.ps1` passes.
