# Screenshots

Instant area screen capture with instant clipboard copy, pin-to-screen, and simple annotations. Replaces: Windows Snipping Tool, CleanShot.

## Brief

```markdown
# Shot

A fast screenshot utility. Press Win+Shift+S, select an area, and copy or annotate immediately.

## Main jobs
1. Interactive rectangle selection overlay across all monitors.
2. Auto-copy captured image to clipboard.
3. Quick annotation toolbar: arrows, rectangles, blur sensitive text, and numbers.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Area selection overlay | Transparent full-screen WinUI 3 Window with mouse tracking | Standard |
| Frame capture | Win32 GDI `BitBlt` or `Windows.Graphics.Capture` | Standard |
| Clipboard output | Win32 `SetClipboardData(CF_DIB, ...)` | Standard |

## Stories

### US-101: Area Drag Selection
- [ ] Freezes screen image and opens dim overlay across all displays.
- [ ] Mouse drag creates an illuminated selection rectangle.

### US-102: Instant Copy & Save
- [ ] Releasing mouse copies image to clipboard and shows desktop toast.
- [ ] Saves PNG file to Screenshots folder.

## Gotchas
- Multi-monitor coordinate systems can feature negative coordinates (e.g. secondary monitor positioned left of primary); normalize bounds relative to the virtual screen rect.
- Snipping overlay must close before clipboard paste or active window switches to prevent occlusion.

## Done when
Area captures copy instantly to clipboard with accurate multi-monitor scaling.
