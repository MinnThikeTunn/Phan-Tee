<div align="center">

# Phan-Tee: Build Any Windows App

### See an app you like. Rebuild it as your own native Windows app.

Agent skills that take a native Windows app from idea to your Taskbar.<br>
C#, WinUI 3, and Fluent Design. Local SQLite data. No Visual Studio GUI required.

[![Windows 10/11](https://img.shields.io/badge/Windows-10%2F11-0078D4?style=flat-square&logo=windows&logoColor=white)](#requirements)
[![.NET 9 / 10](https://img.shields.io/badge/.NET-9%20%2F%2010-512BD4?style=flat-square&logo=dotnet&logoColor=white)](#requirements)
[![21 skills](https://img.shields.io/badge/skills-21-0078D4?style=flat-square)](#skills)
[![Claude Code plugin](https://img.shields.io/badge/Claude_Code-plugin-D97757?style=flat-square&logo=claude&logoColor=white)](#install)
[![Codex plugin](https://img.shields.io/badge/Codex-plugin-10A37F?style=flat-square)](#install)
[![MIT license](https://img.shields.io/badge/license-MIT-F4C430?style=flat-square)](LICENSE)

<br><br>

<img src="asset/Phan-Tee_%20Build%20Any%20Windows%20App.png" alt="Phan-Tee: Build Any Windows App" width="100%" />

<br><br>

**[Quick start](#quick-start) · [How it works](#how-it-works) · [Skills](#skills) · [Specs](#specs) · [Install](#install)**

</div>

## Quick start

```bash
npx skills@latest add MinnThikeTunn/Phan-Tee
```

Then ask your agent:

```text
Clone my to-do app as a native Windows app.
Screenshot every screen, write the user stories, and build milestone 1.
```

Not sure where to start? Type `/phan-tee`. It looks at your project and picks the next skill.

## How it works

<table>
<tr>
<td width="33%" valign="top">

**1. Clone**

Your agent inspects the app you like and screenshots every screen with computer use or window capture. It writes a screen index.

</td>
<td width="33%" valign="top">

**2. Plan**

It turns the screens into user stories with checkable acceptance criteria, organized in milestones.

</td>
<td width="33%" valign="top">

**3. Build**

It builds one story per commit. Before each commit it snapshots every page in light and dark mode and runs the tests.

</td>
</tr>
</table>

## Skills

<table>
<tr><th>Stage</th><th>Skill</th><th>What it does</th></tr>
<tr><td rowspan="3" valign="top"><b>Start</b></td><td nowrap><a href="skills/start/phan-tee/SKILL.md"><samp>phan-tee</samp></a></td><td>Router: finds where you are and calls the right skill</td></tr>
<tr><td nowrap><a href="skills/start/app-brief/SKILL.md"><samp>app-brief</samp></a></td><td>Turns an idea into a one-page brief</td></tr>
<tr><td nowrap><a href="skills/start/new-win-app/SKILL.md"><samp>new-win-app</samp></a></td><td>A working app from a template: WinUI 3, EF Core SQLite, build script, snapshot mode, git</td></tr>
<tr><td rowspan="3" valign="top"><b>Plan</b></td><td nowrap><a href="skills/plan/research/SKILL.md"><samp>research</samp></a></td><td>Parallel researcher agents: market, users, features, design, Win32/WinRT APIs</td></tr>
<tr><td nowrap><a href="skills/plan/clone/SKILL.md"><samp>clone</samp></a></td><td>Screenshots every screen of any app with computer use or window capture, writes a screen index</td></tr>
<tr><td nowrap><a href="skills/plan/user-stories/SKILL.md"><samp>user-stories</samp></a></td><td>A backlog with checkable acceptance criteria, in milestones</td></tr>
<tr><td rowspan="5" valign="top"><b>Code</b></td><td nowrap><a href="skills/code/csharp-winui/SKILL.md"><samp>csharp-winui</samp></a></td><td>C# 13, WinUI 3, MVVM, EF Core SQLite, compiler errors</td></tr>
<tr><td nowrap><a href="skills/code/os-integrations/SKILL.md"><samp>os-integrations</samp></a></td><td>Global hotkeys, taskbar tray, floating panels, window control, screen capture, URI schemes, Named Pipe CLI</td></tr>
<tr><td nowrap><a href="skills/code/performance/SKILL.md"><samp>performance</samp></a></td><td>Measure, then fix: UI thread hangs, stutter, GPU compositing, dotnet-trace from CLI</td></tr>
<tr><td nowrap><a href="skills/code/improve-architecture/SKILL.md"><samp>improve-architecture</samp></a></td><td>Finds hot spots as the app grows and refactors one step per commit, with behavior proven unchanged</td></tr>
<tr><td nowrap><a href="skills/code/agent-cli/SKILL.md"><samp>agent-cli</samp></a></td><td>Optional: a command line and MCP server via Named Pipes, so Claude Code, Codex, and scripts drive your app</td></tr>
<tr><td rowspan="7" valign="top"><b>Design</b></td><td nowrap><a href="skills/design/ux-design/SKILL.md"><samp>ux-design</samp></a></td><td>Names, flow, where each feature opens (inline, flyout, content dialog, window), words, and accessibility</td></tr>
<tr><td nowrap><a href="skills/design/win-design/SKILL.md"><samp>win-design</samp></a></td><td>Fluent Design 2, Mica, Acrylic, NavigationView, CommandBars, keyboard navigation, dark mode</td></tr>
<tr><td nowrap><a href="skills/design/design-system/SKILL.md"><samp>design-system</samp></a></td><td>Native look with system accent color from Windows Personalization, ResourceDictionary tokens</td></tr>
<tr><td nowrap><a href="skills/design/layout-grid/SKILL.md"><samp>layout-grid</samp></a></td><td>A 4px/8px grid with checks that fail on misalignment: a code lint and layout probes in snapshot mode</td></tr>
<tr><td nowrap><a href="skills/design/design-kit/SKILL.md"><samp>design-kit</samp></a></td><td>Your own parts: custom window chrome, token layers, control states, and parts gallery</td></tr>
<tr><td nowrap><a href="skills/design/design-from-app/SKILL.md"><samp>design-from-app</samp></a></td><td>Rebuilds the look of an app from screenshots: measures sizes and colors, compares pixel-by-pixel</td></tr>
<tr><td nowrap><a href="skills/design/app-icon/SKILL.md"><samp>app-icon</samp></a></td><td>A multi-resolution Windows .ico and AppX asset suite generated from clean SVG layers</td></tr>
<tr><td rowspan="3" valign="top"><b>Ship</b></td><td nowrap><a href="skills/ship/build-and-verify/SKILL.md"><samp>build-and-verify</samp></a></td><td>Build, install, snapshot every page in light and dark, look at them</td></tr>
<tr><td nowrap><a href="skills/ship/test-win-app/SKILL.md"><samp>test-win-app</samp></a></td><td>xUnit unit tests, an in-app self-test, a Named Pipe debug bridge an agent can drive</td></tr>
<tr><td nowrap><a href="skills/ship/improve-loop/SKILL.md"><samp>improve-loop</samp></a></td><td>Works through the backlog one story per commit until a milestone is done</td></tr>
</table>

## Specs

Not sure what to build? [specs/](specs/) has 12 build plans for native Windows utility apps: a window snapper, a window switcher, a quick launcher, clipboard history, taskbar stats, screenshots, a screen recorder, and more. Copy one into an empty folder and tell your agent:

```text
Build the app in window-snapper.md with Phan-Tee.
```

## Install

Pick one route per agent.

<details open>
<summary><b>Universal 1-Liner (All Agents & Global)</b></summary>

Installs Phan-Tee across all detected agents on your computer (Claude Code, Codex, Cursor, Antigravity, Copilot, Zed):

```bash
npx skills@latest add MinnThikeTunn/Phan-Tee -g -y
```

</details>

<details>
<summary><b>Claude Code</b></summary>

Via Claude Plugin Marketplace:

```text
/plugin marketplace add MinnThikeTunn/Phan-Tee
/plugin install phan-tee@phan-tee
```

Or via skills CLI:

```bash
npx skills@latest add MinnThikeTunn/Phan-Tee -a claude-code
```

</details>

<details>
<summary><b>Codex</b></summary>

Via Codex Plugin Marketplace:

```bash
codex plugin marketplace add MinnThikeTunn/Phan-Tee
codex plugin add phan-tee@phan-tee
```

Or via skills CLI:

```bash
npx skills@latest add MinnThikeTunn/Phan-Tee -a codex
```

</details>

<details>
<summary><b>Cursor, Antigravity, Copilot, Zed, Cline</b></summary>

Uses [skills.sh](https://skills.sh). Install for a specific agent, or pick specific skills:

```bash
npx skills@latest add MinnThikeTunn/Phan-Tee -a cursor
npx skills@latest add MinnThikeTunn/Phan-Tee -a antigravity
npx skills@latest add MinnThikeTunn/Phan-Tee -a copilot
npx skills@latest add MinnThikeTunn/Phan-Tee --skill=clone
```

</details>

<details>
<summary><b>By hand / Offline (PowerShell)</b></summary>

```powershell
git clone https://github.com/MinnThikeTunn/Phan-Tee.git
.\Phan-Tee\scripts\link-skills.ps1       # links every skill into ~/.claude/skills, ~/.agents/skills, and ~/.gemini/config/skills
```

</details>

## Requirements

- Windows 10 (version 1809+ / build 17763+) or Windows 11 (recommended)
- .NET 9.0 SDK or .NET 10.0 SDK (`dotnet --version`)
- PowerShell 5.1 (standard in Windows) or PowerShell 7 (`pwsh`)
- An agent that supports skills: Claude Code, Codex, Cursor, Gemini CLI, Antigravity

## Credits

- Inspired by and architected after **BAMA** (*Build Any Mac App*) by Dave Ebbelaar and **REA** (*Reverse Engineer Anything*) by morluto.
- Skill format and conventions follow Matt Pocock's `writing-for-agents`.

## License

[MIT](LICENSE)
