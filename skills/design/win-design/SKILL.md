---
name: win-design
description: Design rules that make a WinUI 3 app look and feel like a native Windows 11 app, from Fluent Design System 2 to Mica, NavigationView, CommandBars, menus, keyboard accelerators, Segoe UI Variable, and dark mode. Use when building or reviewing any window, page, CommandBar, or dialog.
---

# Windows 11 Design

Microsoft already designed your app. Pick the right system parts, arrange
them, and stay out of their way.

- Design checklist: [design-rules.md](design-rules.md).
- Copyable XAML patterns: [patterns.md](patterns.md).

## Microsoft's Five Fluent Principles

1. **Natural**: Adapts to user input (keyboard, mouse, touch, pen).
2. **Intuitive**: Familiar layouts, consistent iconography, clear hierarchy.
3. **Responsive**: Instant feedback, smooth micro-animations.
4. **Intentional**: Every visual element serves a purpose.
5. **Crafted**: Aligned edges, consistent 4 px / 8 px grid spacing, polished materials.

## Windows 11 Visual Materials

- **Mica (`MicaBackdrop`):** Applied to the main window frame. Dynamically samples the user's desktop wallpaper to create a subtle tinted surface.
- **Acrylic (`DesktopAcrylicBackdrop`):** Used for transient floating flyouts, context menus, and dialogs.
- **Corners:** Windows 11 standard 8 px corner radius for cards and buttons; 4 px for small chips.
- **Typography:** Segoe UI Variable with dynamic optical sizing.
- **Icons:** Segoe Fluent Icons (`FontIcon Glyph="\uE..."`).

## Done when

All views and flyouts use standard Fluent 2 controls, Mica or Acrylic backdrops are applied, and typography conforms to Segoe UI Variable.
