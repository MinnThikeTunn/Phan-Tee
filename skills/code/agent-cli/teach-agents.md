# Teaching Agents How to Drive the App

When your app ships an agent CLI, AI assistants like Claude Code, Codex, or Antigravity can interact with it automatically.

Add this instruction to your project's `CLAUDE.md`:

```markdown
## Driving the app via CLI
Use the `<cli-name>` CLI tool to query and manipulate data:
- `<cli-name> items list --json`
- `<cli-name> items add --title "..." --json`
- `<cli-name> status --json`
```
