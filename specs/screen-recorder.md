# Screen recorder

Record full desktop, selected window, or custom area to MP4 with system and microphone audio. Replaces: OBS, Camtasia, ShareX.

## Brief

```markdown
# Record

A clean screen and window recorder that produces optimized MP4 video files.

## Main jobs
1. Record full screen or selected app window with zero dropped frames.
2. Record system audio and optional microphone input.
3. Instant recording controls floating overlay with Pause and Stop buttons.
```

## How it works

| Part | API | Privilege |
| --- | --- | --- |
| Screen capture | `Windows.Graphics.Capture.GraphicsCaptureItem` | Standard |
| Direct3D frame pool | `Direct3D11CaptureFramePool` | Standard |
| Video encoding | Windows Media Foundation / `MediaComposition` (H.264/AAC MP4) | Standard |
| Audio capture | WASAPI loopback capture (`AudioClientShareMode.Shared`) | Standard |

## Stories

### US-101: Window and Display Capture
- [ ] Prompts `GraphicsCapturePicker` to select target window or display.
- [ ] Renders a subtle yellow border indicating active capture.

### US-102: Audio Sync & MP4 Export
- [ ] Captures system audio and microphone streams via WASAPI.
- [ ] Finalizes MP4 container on stop and saves to Videos folder.

## Gotchas
- Windows Graphics Capture requires a Direct3D 11 device initialized on the thread. Dispose textures immediately to prevent pool starvation.
- Audio and video timestamps must use a common monotonic clock (`QueryPerformanceCounter`) to avoid progressive drift.

## Done when
Recording produces smooth, playback-ready MP4 files with synchronized audio.
