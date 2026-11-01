---
name: design-from-app
description: Rebuild the visual design of any Windows app from its screenshots, measuring dimensions, spacing, and colors, then comparing pixel-by-pixel until it matches. Use when cloning or rebuilding a reference app.
argument-hint: "<reference.png> <build.png>"
---

# Design from app

Rebuilding an app from screenshots is an iterative loop:

```text
measure reference -> implement in XAML -> build -> snap.ps1 -> compare.ps1 -> fix -> repeat
```

1. **Measure:** Use `scripts/measure.ps1` to sample exact RGB colors and bounding boxes.
2. **Implement:** Translate the measured layout into standard Fluent controls and `Space` scale tokens.
3. **Compare:** Run `scripts/compare.ps1` to produce `side-by-side.png` and `diff.png`.
4. Fix layout discrepancies until the diff is minimal and native controls shine.

## Done when

`diff.png` shows alignment with the reference app while utilizing native WinUI 3 controls.
