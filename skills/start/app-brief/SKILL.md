---
name: app-brief
description: One-page brief (docs/BRIEF.md) for a new Windows app, written before any code. Use when the user has an app idea, wants to replace an app they pay for, or the research and clone skills are done.
argument-hint: "[idea in a few words]"
---

# App brief

Write `docs/BRIEF.md` in a folder named after the app
(`<parent>/<AppName>/docs/BRIEF.md`; ask for the parent folder, default
`~/Developer` or `C:\Developer`). Every later skill reads it. Keep it to one page.

## 1. Name and read what exists

Pick the name first: one UpperCamelCase word (`Tasks`, `DailyLog`), not the
name of an app already installed on Windows, and an app id
`com.<yourname>.<appname>` in lowercase. The folder, the research, and the
scaffold all use it.

If `docs/research/` or `docs/screens/INDEX.md` exist, read them first.
Skip every question they already answer.

If the user gives you a spec from Phan-Tee's `specs/` folder (a file or a
link), it already holds the brief and the stories. Copy its **Brief** block
to `docs/BRIEF.md` and its **Stories** block to `docs/STORIES.md`. Keep the
rest of the spec as `docs/SPEC.md`, so later skills read its **How it
works** and **Gotchas**. Ask only what the user wants to change, then call
the Skill tool with `new-win-app`.

## 2. Interview

Ask a few questions at a time. If the user asked you to decide everything,
answer each question yourself from the research, write the choice in the
brief, and note "decided by the agent" next to it.

1. What do you do today, and which app or habit does it replace?
2. What are the three things you do most often? These become the main pages.
3. What data does it hold? Name the nouns: tasks, notes, recipes, invoices.
4. Is there a reference app you like? Then the `clone` skill comes next.
5. Where does it live: a window with a navigation pane, a taskbar tray icon,
   a quick-capture panel with a global shortcut, or a mix?
6. Does it need the internet? Default: no.
7. Which three things are out of scope for version one?
8. Should it look like a built-in Windows 11 app, or have its own look? Note a
   brand or accent color, and any app they name: the `design-from-app` skill
   rebuilds its look. No answer means native with Windows Personalization accent.

## 3. Cut scope

A personal app has one user. Remove what exists only for other users:
accounts, sharing, teams, sync servers, billing, onboarding, analytics.

Version one is one afternoon of agent time: one window, two to five main
pages, one data model with two to four types. Filtered views of one
model (Today, Upcoming, Someday) count as one page.

## 4. Write docs/BRIEF.md

Use this exact structure:

```markdown
# <AppName>

<One sentence: what the app does, who it is for, and which app or habit it replaces.>

## Main jobs
1. <Verb + noun + purpose: Add a task in under two seconds.>
2. ...

## Pages
- **<Page 1>**: <what it shows, how it sorts, the primary action.>
- **<Page 2>**: ...
- **Settings**: <appearance, database location, shortcuts.>

## Data
- `<Type>`: <fields, types, default values. Stored in local SQLite.>

## System hooks
<Taskbar tray, global shortcuts, notifications, startup registry, or none.>

## Look
<Native Fluent Design with Windows accent color, or a named brand color.>

## Not in version one
- <Thing 1>
- <Thing 2>
```

## Done when

`docs/BRIEF.md` exists, has all sections, and the user approved it or you
noted which parts the agent decided.
