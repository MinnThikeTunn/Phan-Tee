---
name: layout-grid
description: Grid and alignment rules for a Windows WinUI 3 app, with checks that catch misalignment (tools/grid-lint.ps1 for off-grid numbers and tools/check-layout.ps1 for layout probes). Use when building or reviewing pages, cards, forms, or after layout edits.
---

# Layout grid

Agents guess numbers. A guessed `Margin="13"` looks almost right and makes
the whole app feel slightly off. This skill replaces guessing with one scale
and automated checks that fail when something is off.

## The rules

1. Every padding, margin, spacing, and size comes from `Space`:
   `Xs (4)`, `Sm (8)`, `Md (12)`, `Lg (16)`, `Xl (20)`, `Xxl (24)`, `Section (32)`, `Margin (24)`.
   Raw numbers must be 0, 1, 2, or a multiple of 4.
2. Windows have a 24 px margin. Cards pad 16 px. Related controls sit 8 px apart.
3. Nested corners are concentric: `innerRadius = outerRadius - padding`.
4. Truncate long text with `TextTrimming="CharacterEllipsis"` and full text in tooltip.

## Check 1: Lint the code

Run after every build that touches XAML:

```powershell
.\tools\grid-lint.ps1
```

Fix any flagged line with a multiple of 4 or silence with `// grid: ok <why>`.

## Check 2: Probe the real layout

In snapshot mode, layout probes record actual coordinates into `*-layout.json`.
Validate them:

```powershell
.\tools\check-layout.ps1
```

## Done when

`tools\grid-lint.ps1` and `tools\check-layout.ps1` both print `PASS`.
