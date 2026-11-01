# Color picker

Screen eyedropper magnifier and color palette history. Pick any pixel color from anywhere on screen, copy HEX/RGB/HSL to clipboard, and save color palettes. Replaces: PowerToys Color Picker.

## Brief

```markdown
# Pick

An instant screen eyedropper that zooms into pixels under the mouse and copies color codes.

## Main jobs
1. Press Win+Shift+C to open the circular pixel magnifier following the mouse cursor.
2. Click to sample the pixel color.
3. Automatically format and copy HEX (#0078D4) or RGB to the clipboard.
4. Save recent color palette history locally.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Global shortcut | Win32 `RegisterHotKey` | Standard |
| Screen sampling | GDI `GetDC(NULL)`, `GetPixel(hdc, x, y)` | Standard |
| Magnifier HUD | Circular layered window following mouse cursor | Standard |
| Clipboard copy | Win32 `SetClipboardData` | Standard |

## Stories

### US-101: Cursor Magnifier Eyedropper
- [ ] Win+Shift+C opens the magnifier HUD centered on cursor.
- [ ] Magnifier displays pixel grid and central hex color code.

### US-102: Sample and Copy
- [ ] Left-click copies the formatted HEX code to clipboard.
- [ ] Escape dismisses without copying.

## Gotchas
- Multi-monitor setups with mixed DPI scales require Per-Monitor V2 DPI awareness to sample correct virtual screen coordinates.
- HDR displays require tone mapping adjustments when converting RGB values from HDR framebuffers.

## Done when
Eyedropper opens smoothly, magnifies pixels, and copies accurate color values.
