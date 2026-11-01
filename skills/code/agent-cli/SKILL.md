---
name: agent-cli
description: Optional command line and MCP server for a Windows app, so Claude Code, Codex, and scripts can drive it (list, add, change, search, act) through the running app. Use when the user wants agents to work with their app or its data, asks for a CLI, an MCP server, or automation.
argument-hint: "<cli-name, like tasks or notes>"
---

# Agent CLI

Give the app a command line, so an AI agent can do everything a person can
do in the window: `tasks items add --title "Call client"`. The app
binary is the CLI. Each command goes to the running app over a private
Windows Named Pipe (`\\.\pipe\<app>-ipc`), executes there like a button click,
and the window updates live.

```text
Claude Code --PowerShell--> tasks items add ...  --Named Pipe--> Tasks.exe (runs command, saves, redraws)
Claude Desktop --MCP------> tasks mcp           --Named Pipe--> same commands, same app
```

## CLI, MCP, or Shortcuts

| Way in | Who uses it | Ship it |
| --- | --- | --- |
| CLI | Claude Code, Codex, scripts, people in PowerShell | Always. Agents learn it from `--help`. |
| MCP (`tasks mcp`) | Claude Desktop and clients with no shell access | Optional. Same commands exposed as tools. |

The CLI talks to the running app over the Named Pipe, never directly to the
database file. Then there is one writer, checks and side effects run, and
the window shows changes at once. If the app is closed, the CLI launches it
in the background.

## 1. List the commands

Read `docs/STORIES.md`. Write each action as `<noun> <verb>`:
- **read**: `items list`, `items show`, `status`
- **write**: `items add`, `items update`, `open`
- **destructive**: `items delete` (requires `--yes` flag)

## 2. Add the files

```powershell
& "${PHANTEE_SKILL_DIR}\scripts\add-agent-cli.ps1" <app-folder> <cli-name>
```

## 3. Build and test

```powershell
.\build.ps1
& "${PHANTEE_SKILL_DIR}\scripts\check-agent-cli.ps1" <cli-name>
```

## Done when

`<cli-name> --help` prints the available commands, and running a test add
command updates the running window live.
