---
name: app-icon
description: Windows app icon made from vector SVG layers, compiled into multi-resolution AppIcon.ico and AppX assets via tools/make_icon.ps1, and reviewed across sizes with tools/icon_review.ps1. Use when the user wants an app icon or better Taskbar icon.
---

# App icon

The icon is stored as vector SVG: `Assets/Icon/AppIcon.svg`.
Windows requires multi-resolution icon binaries (`.ico`) containing 16x16,
24x24, 32x32, 48x48, 64x64, 128x128, and 256x256 RGBA renditions.

- `tools\make_icon.ps1` compiles `Assets\Icon\AppIcon.svg` into `AppIcon.ico`.
- `tools\icon_review.ps1` renders a contact sheet of all sizes for agent review.

## Guidelines for a Great Windows Icon

1. **One clear object:** A single recognizable symbol (a checkmark for tasks, a waveform for audio).
2. **High contrast:** Thin strokes vanish at 16x16 px in the notification tray. Use solid, bold shapes.
3. **No text:** Never put letters or screenshots inside the icon.
4. **Distinct silhouette:** Must stand out cleanly against both light and dark Windows Taskbars.

## Steps

1. Create or edit `Assets\Icon\AppIcon.svg`.
2. Run `.\tools\make_icon.ps1`.
3. Review with `.\tools\icon_review.ps1`.

## Done when

`AppIcon.ico` is compiled and looks crisp on both dark and light taskbars across 16 px and 256 px resolutions.
