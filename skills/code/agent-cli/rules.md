# Agent CLI Rules

1. **One Writer:** Commands must communicate with the running app instance via Named Pipe `\\.\pipe\<app>-ipc` instead of opening the SQLite database directly.
2. **Deterministic Output:** All CLI commands support `--json` output format for agent parsing.
3. **Guard Destructive Actions:** Deletions require `--yes` flag to execute; otherwise, print a dry-run confirmation message.
4. **Fast Response:** Every command must respond within 500 ms.
