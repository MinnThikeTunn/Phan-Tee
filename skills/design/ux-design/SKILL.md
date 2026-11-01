---
name: ux-design
description: UX design rules for a native Windows app, including surfaces (flyout, content dialog, window), terminology, button placement, and accessibility. Use when designing user flow, before writing views, or when adding an action or dialog.
---

# UX design

Apple designed Mac apps, and Microsoft designed Windows apps. Pick the right
system parts, arrange them, and stay out of their way.

## Windows Surface Hierarchy

| Want | Surface | Behavior |
| --- | --- | --- |
| Quick confirmation or single field | `ContentDialog` | Modal, dims background, Primary/Secondary/Close buttons |
| Contextual options or mini form | `Flyout` / `MenuFlyout` | Transient, opens next to button, closes on outside click |
| Permanent feature or navigation | Page inside `NavigationView` | Main window content frame |
| Global quick-capture panel | Floating WinUI 3 Window | Opened via global shortcut, closed on Escape |

## Copy Rules

- Use Windows terminology:
  - "Settings", not "Preferences"
  - "Recycle Bin", not "Trash"
  - "Taskbar", not "Dock"
  - "File Explorer", not "Finder"
- Sentence case for titles, headings, and buttons: "Save changes", "Add task", "Delete item".

## Accessibility

- All buttons have `AutomationProperties.Name`.
- Keyboard navigation (Tab, Arrow keys, Enter, Escape) works across every page.

## Done when

Interactive flows, error states, and keyboard navigation paths are documented, and all controls include `AutomationProperties.Name`.
