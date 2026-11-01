---
name: os-integrations
description: Deep Windows integrations for a native app, such as global hotkeys, taskbar system tray items, floating panels, window control with Win32, screen capture, clipboard monitoring, OCR, URI schemes, startup at login, and Named Pipes. Use when an app must reach outside its own window or control other apps.
---

# Windows integrations

A Windows desktop app is a set of entry points around the OS, not just one
window. This skill picks the API for each entry point. Complete copyable C#
code for every row is in [recipes.md](recipes.md).

## Pick the API

| Want | API | Privilege Required |
| --- | --- | --- |
| Global shortcut (key combo) | Win32 `RegisterHotKey` | Standard User |
| Keystroke monitoring / Hold-to-show | Win32 `SetWindowsHookEx(WH_KEYBOARD_LL)` | Standard User |
| List other apps' windows | Win32 `EnumWindows` + `GetWindowText` | Standard User |
| Move and resize other apps' windows | Win32 `SetWindowPos` | Standard User |
| Taskbar system tray icon | Win32 `Shell_NotifyIconW` or `H.NotifyIcon` | Standard User |
| Spotlight / PowerToys-style floating panel | Win32 `WS_EX_NOACTIVATE \| WS_EX_TOOLWINDOW` | Standard User |
| Screen capture and recording | `Windows.Graphics.Capture` API | Standard User |
| Clipboard history listener | Win32 `AddClipboardFormatListener` | Standard User |
| On-device OCR text recognition | `Windows.Media.Ocr.OcrEngine` | Standard User |
| Launch at Windows startup | Registry `HKCU\Software\Microsoft\Windows\CurrentVersion\Run` | Standard User |
| Deep links / URI schemes | Registry `HKCU\Software\Classes\<scheme>` | Standard User |
| Prevent PC/display from sleeping | Win32 `SetThreadExecutionState` | Standard User |
| System notifications | Windows App SDK `AppNotificationManager` | Standard User |
| Agent or script reads/changes data | Windows Named Pipes (`agent-cli` skill) | Standard User |

## Done when

You picked the API from the table and followed the exact recipe in `recipes.md`.
