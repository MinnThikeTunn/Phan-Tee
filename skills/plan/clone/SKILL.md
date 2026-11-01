---
name: clone
description: Walk through any existing Windows app (native or web), screenshot every screen, menu, and dialog, write a screen index, and turn it into user stories. Use when the user wants to clone, rebuild, replace, or copy the design of an app, or says "screenshot every screen".
argument-hint: "<app name as in Task Manager, or a URL>"
---

# Clone

Output: a folder of screenshots, one index that describes everything the
app shows, and a backlog built from it.

```text
docs/screens/
  INDEX.md
  01-inbox.png
  02-today.png
  ...
docs/STORIES.md      (from the user-stories skill)
```

## 1. Pick the tool

| The app is | Use |
| --- | --- |
| A native Windows app, or Electron | Computer use or `window-shot.ps1` |
| A web app | A browser tool: built-in browser or Playwright |

## 2. Agree on privacy

Tell the user you will see everything in the app. Suggest a demo account or
sample data. Look, do not touch: open screens and menus, press Escape to
close dialogs. Type or change data only when instructed.

## 3. Save real files

Save each screen at full resolution with the script in this skill:

```powershell
& "${PHANTEE_SKILL_DIR}\scripts\window-shot.ps1" "<AppName>" docs/screens/01-inbox.png
```

## 4. Walk the app in this order

1. Main window, default page.
2. Every navigation item, top to bottom.
3. Every view mode (list, grid, board), sort menu, filter menu.
4. One item opened in detail: fields, notes, status.
5. Creation flows: add button, quick-add panel, inline editor.
6. Context menus on an item, a section, a navigation entry.
7. Title bar, menu bar, and CommandBar items.
8. Settings: every tab.
9. Empty states.
10. Dark mode: the main pages again.

## 5. Write docs/screens/INDEX.md

One section per screenshot:

```markdown
## 01-inbox.png

Page: Inbox. Reached from: NavigationView > Inbox.
Layout: CommandBar at top with Add button; master list; detail pane on the right.
Elements: task row (checkbox, title, description, star icon).
Actions: complete, select, star, delete.
Shortcuts seen: Ctrl+N (new task), Delete (delete task).
```

## Done when

`docs/screens/INDEX.md` exists and lists every capture, and you called the
`user-stories` skill.
