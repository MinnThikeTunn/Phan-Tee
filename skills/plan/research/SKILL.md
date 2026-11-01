---
name: research
description: Online research for a Windows app before building it, run as parallel researcher subagents, saved to docs/research/. Use when the user asks what to build, which features matter, how the best apps in a category work, how a Windows API or integration works, or wants a feature comparison.
argument-hint: "<app category or question>"
---

# Research

Research answers three questions before code exists: what the best apps in
the category do, what users love and hate about them, and how Windows lets
you build it. The output feeds `app-brief` and `user-stories`.

## 1. Frame

Write the question in one line, and the decision it informs ("which
features go in version one", "RegisterHotKey or low-level keyboard hook"). If the user
gave only a category, the question is "what makes the best <category> app
on Windows".

## 2. Fan out

Start one subagent per track, in parallel, with the brief below. Pick the
tracks that fit. Four is typical. Market and Reviews always run. Reviews
covers many apps: give each subagent 3 or 4 apps, or the 600 words run out.

| Track | Finds |
| --- | --- |
| Market | The 5 to 8 best apps in the category, their price, platform, and headline features |
| Reviews | Per app: what people like and what they dislike, from Microsoft Store reviews, Reddit, Hacker News, forums, and "switched from X" posts |
| Features | The full feature list of the 2 or 3 leaders, from docs, changelogs, and help pages |
| Design | Screens, interaction details, and keyboard shortcuts of the leaders |
| Platform | The Windows APIs (Win32, WinRT, Windows App SDK), permissions, and limits each feature needs |

Subagent brief:

```text
Research [track] for a native Windows app that [one-line idea].
Question: [the question]. Decision it informs: [decision].
Search the web. Prefer primary sources: official docs, changelogs, Microsoft
developer docs, Windows App SDK documentation, the app's own help pages. Use reviews and
forums for opinions only. Do not write any files.
Tag every claim: [V] verified in a source (give the URL), [K] from your
own knowledge, [U] unverified, must be tested.
Return at most 600 words: a findings list, a table where it helps, and
the 3 things that matter most for the decision. No intro, no summary.
```

## 3. Merge

Write one file per question: `docs/research/<topic>.md`.

```markdown
# <Topic>

Research for <AppName>. Done <YYYY-MM-DD>.
[V] verified in a source, [K] from knowledge, [U] unverified, test first.

## Findings
- ... [V](url)

## Comparison
| App | Pros | Cons | Price |
| --- | --- | --- | --- |

## Decisions for version one
1. ...
```

## Done when

`docs/research/<topic>.md` exists, every claim is tagged, and you called the
next skill (`app-brief` or `user-stories`).
