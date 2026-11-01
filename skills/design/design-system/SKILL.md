---
name: design-system
description: Accent color and design system for a Windows app, from Windows Personalization accent adaptation to XAML ResourceDictionary tokens and design/DESIGN-SYSTEM.md. Use when the user asks for themes, styling tokens, or brand colors.
---

# Design system

A design system is a short list of **tokens** in XAML resources and one page
that says which token to use when. Every screen uses tokens, never hard-coded values.

## 1. System Accent Color

By default, Phan-Tee apps adopt the user's system accent color configured in
Windows Settings > Personalization > Colors.

- Use `{ThemeResource AccentFillColorDefaultBrush}` for prominent buttons and highlights.
- Use `{ThemeResource TextFillColorPrimaryBrush}` for primary text.
- Use `{ThemeResource TextFillColorSecondaryBrush}` for secondary captions.
- Use `{ThemeResource CardBackgroundFillColorDefaultBrush}` for card backgrounds.

## 2. Spacing & Radius Tokens

- Spacing scale: `Space.Xs (4)`, `Space.Sm (8)`, `Space.Md (12)`, `Space.Lg (16)`, `Space.Xl (20)`, `Space.Xxl (24)`, `Space.Margin (24)`.
- Corner radii: Controls = 8 px, Chips/Badges = 4 px.

## Done when

Views reference theme tokens and `design/DESIGN-SYSTEM.md` defines which token to use where.
