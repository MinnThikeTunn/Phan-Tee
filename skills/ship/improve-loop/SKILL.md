---
name: improve-loop
description: Autonomous loop that works through docs/STORIES.md one story at a time for a Windows app, building, snapshotting, comparing against reference screenshots, fixing, and committing, until a milestone is done. Use when the user says "keep going", "work through the backlog", or wants an unattended improvement loop.
argument-hint: "[milestone, e.g. M1]"
---

# Improve loop

One pass through the loop takes one story from `todo` to `done`:

```text
pick story -> plan -> code -> .\build.ps1 -> .\tools\snap.ps1 -> compare -> fix -> commit -> update STORIES.md
```

Stop after the milestone the user named (default: current milestone), then report.

## 1. Pick

Open `docs/STORIES.md`. Take the first `todo` story in the current
milestone whose dependencies are `done`. Set it to `doing`.

## 2. Plan

Write two to five lines before editing code: which files change, which
models need new fields, and which snapshot page will verify it.

## 3. Code

Follow `csharp-winui` and `win-design`. Keep logic in `<AppName>Core` and
views in `<AppName>`.

## 4. Build and Snapshot

```powershell
.\build.ps1
.\tools\snap.ps1
```

If the story has logic, add a unit test or self-test check (`test-win-app`).

## 5. Compare

Inspect your snapshot alongside reference screenshots or acceptance criteria:
1. Missing or wrong behavior from acceptance criteria.
2. Words and flow (Windows sentence case, native controls).
3. Layout alignment and grid checks (`tools\grid-lint.ps1`).

Fix and snapshot again (maximum 3 iterations per story).

## 6. Commit and Record

```powershell
git add -A
git commit -m "Complete task with Ctrl+Enter"
```

Update the story to `done` in `docs/STORIES.md`. One story per commit.

## 7. Report

Report stories done, snapshot image paths, and run `.\build.ps1 -Open` so
the user can test the build.

## Done when

All stories in the milestone are committed, snapshots are verified, and `build.ps1 -Open` runs cleanly for the user.
