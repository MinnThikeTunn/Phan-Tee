# Clipboard history

Searchable clipboard history with multi-format support, instant preview, and direct paste into the frontmost app. Replaces: Windows Clipboard (Win+V), Paste.

## Brief

```markdown
# Clip

A clipboard manager that remembers copied text, code snippets, and images, and pastes them on command.

## Main jobs
1. Record clipboard history in a local SQLite database with zero cloud sync.
2. Press Ctrl+Shift+V to open a floating search popup.
3. Select an item and paste it directly into the active window.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Clipboard listener | Win32 `AddClipboardFormatListener` | Standard |
| Read clipboard formats | Win32 `OpenClipboard`, `GetClipboardData` (CF_UNICODETEXT, CF_DIB) | Standard |
| Direct paste | Copy item to clipboard, then simulate Ctrl+V via `SendInput` | Standard |
| Local database | EF Core SQLite in `%LOCALAPPDATA%\Clip\clip.db` | Standard |

## Stories

### US-101: Capture Clipboard Copies
- [ ] Listens to clipboard changes via AddClipboardFormatListener.
- [ ] Saves Unicode text and preview thumbnails in local SQLite database.

### US-102: Floating Search and Paste
- [ ] Pressing Ctrl+Shift+V opens a floating list near the cursor.
- [ ] Selecting an item pastes it into the active target app via SendInput.

## Gotchas
- When the app writes to the clipboard to perform a paste, it triggers its own clipboard listener; ignore internal updates via an internal state flag.
- Certain password managers mark clipboard entries with `Clipboard Viewer Ignore` format; respect this format to protect user secrets.

## Done when
Every clipboard copy is saved locally, and selecting an item pastes it into the active target app.
