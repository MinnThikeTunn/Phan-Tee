---
name: user-stories
description: Turn a brief or screen index into a backlog (docs/STORIES.md) for a Windows app, with checkable acceptance criteria, organized in milestones. Use when the brief is done, or before writing code.
---

# User stories

Output: `docs/STORIES.md`, the single backlog for the app. Every later skill
works through it, one story per commit.

## 1. Milestones

Organize stories into 3 to 4 milestones:

- **M1: Skeleton.** The app opens, loads real local data from SQLite, shows the main list and detail, and can add an item. Proves the toolchain and local data loop.
- **M2: Core workflow.** The main jobs from the brief: editing, deleting, filtering, starring, and keyboard shortcuts.
- **M3: Polish & OS hooks.** System tray icon, global hotkeys, settings dialog, light/dark theme adaptation.
- **M4: Extensions (optional).** Export, import, agent CLI.

## 2. Story format

Every story ends on checkable acceptance criteria and states its verification level:

```markdown
### US-101: Create task with Ctrl+N [snap] [self]
Status: todo

As a user,
I want to press Ctrl+N to create a new task,
So that I can quickly capture my thoughts.

Acceptance criteria:
- [ ] Pressing Ctrl+N focuses a new row in the list with title "New Task"
- [ ] The item persists to SQLite immediately
- [ ] Empty titles are rejected
- [ ] Snapshot shows the new item in both light and dark mode

Verification:
- self: verify AddItem persists to SQLite
- snap: inbox-light.png shows the new item
```

## Done when

`docs/STORIES.md` exists, M1 has 3 to 6 stories, every story has checkable
acceptance criteria and verification tags, and you called `new-win-app` or `improve-loop`.
