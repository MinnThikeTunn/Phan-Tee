# Text snippets

System-wide text expansion and snippet manager. Type a short abbreviation (e.g. `;email`) and have it automatically expand into full text or code templates. Replaces: TextExpander, AutoHotkey.

## Brief

```markdown
# Snippet

A text expander that monitors keystrokes and replaces abbreviation triggers instantly.

## Main jobs
1. Detect abbreviation triggers across any running application.
2. Backspace the trigger chars and type the replacement text via SendInput.
3. Manage snippet library with tags, dynamic dates, and clipboard placeholders.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Keystroke detection | Win32 `SetWindowsHookEx(WH_KEYBOARD_LL)` | Standard |
| Keystroke simulation | Win32 `SendInput` (backspace trigger + type replacement) | Standard |
| Storage | Local SQLite database in `%LOCALAPPDATA%\Snippet\snippets.db` | Standard |

## Stories

### US-101: Abbreviation Expansion
- [ ] Monitors typed keys in buffer and identifies matches with configured triggers.
- [ ] Simulates backspaces followed by replacement string via `SendInput`.

### US-102: Snippet Management
- [ ] WinUI 3 settings window allows creating, editing, and categorizing snippets.
- [ ] Supports dynamic variables such as `{date}` and `{clipboard}`.

## Gotchas
- When simulating backspaces and replacement keys with `SendInput`, the low-level keyboard hook will intercept its own synthetic input; track an injection state flag to ignore simulated events.
- Certain high-privilege windows (elevated Administrator prompts) block hooks from standard-privilege processes due to UIPI (User Interface Privilege Isolation).

## Done when
Typing abbreviation triggers replaces text cleanly in Notepad, browsers, and terminal.
