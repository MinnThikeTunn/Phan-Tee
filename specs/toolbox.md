# Toolbox

System utility panel for quick toggles: keep awake, empty Recycle Bin, toggle Dark Mode, and switch audio output devices. Replaces: PowerToys Awake, AudioSwitcher.

## Brief

```markdown
# Tool

A floating utility panel or tray popup providing one-click system controls.

## Main jobs
1. Keep Awake toggle: prevents PC from sleeping indefinitely or for timed intervals.
2. Dark Mode toggle: flips Windows system and app themes between Light and Dark.
3. Audio switcher: quick switch between headphones and speakers.
4. Empty Recycle Bin with sound.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Keep awake | Win32 `SetThreadExecutionState` | Standard |
| Dark mode toggle | Registry `HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize` | Standard |
| Empty recycle bin | Win32 `SHEmptyRecycleBin(hWnd, NULL, SHERB_NOCONFIRMATION)` | Standard |
| Audio endpoints | CoreAudio COM `IPolicyConfig` or `IMMDeviceEnumerator` | Standard |

## Stories

### US-101: Keep Awake Toggle
- [ ] Toggle invokes `SetThreadExecutionState` to prevent display sleep.
- [ ] Tray indicator reflects active awake status.

### US-102: System Utilities
- [ ] One-click button empties Windows Recycle Bin.
- [ ] One-click switch toggles system Light / Dark mode in registry.

## Gotchas
- `SetThreadExecutionState` must be renewed or held open by a persistent thread; if the calling thread terminates, the execution state resets automatically.
- Toggling the Windows Theme registry key requires broadcasting `WM_SETTINGCHANGE` to notify active desktop windows to redraw immediately.

## Done when
Toggles activate and revert system states cleanly with zero elevated permissions.
