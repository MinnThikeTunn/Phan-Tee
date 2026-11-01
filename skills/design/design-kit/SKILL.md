---
name: design-kit
description: Custom component system for a Windows app when the user wants their own parts instead of Microsoft's defaults. Includes custom controls, bespoke states, and parts gallery. Use when building a unique branded look.
---

# Design kit

When an app should not look like standard Windows, build your own parts
with a Design Kit:
- Bespoke XAML UserControls and custom styles.
- Token layers for surface elevations, outlines, and hover fills.
- A parts gallery view (`APP_KIT_GALLERY=1`) showing all controls in all states.

Read [kit-spec.md](kit-spec.md) for specs and token layering rules.

## Done when

Custom tokens and control states are defined in ResourceDictionaries and verified against [kit-spec.md](kit-spec.md).
