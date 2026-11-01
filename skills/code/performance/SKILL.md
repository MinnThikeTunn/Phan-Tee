---
name: performance
description: Make a Windows app fast by measuring hangs, stutter, CPU, memory, and UI stalls, then moving work off the UI thread and onto the GPU. Use when the app freezes, a shortcut feels slow, dragging stutters, memory grows, or the user asks to profile.
---

# Performance

Fast means two numbers: the first frame after a key press shows in under
100 ms, and nothing on the UI thread blocks for more than 50 ms. Every
change starts and ends with a **measurement**, so you know it helped.

## The loop

```text
reproduce -> measure (release build) -> find the line -> fix -> measure again -> commit with numbers
```

1. **Reproduce.** Write the exact steps, or run a probe command that logs
   the elapsed time of each step.
2. **Measure the release build.** Debug builds have heavy diagnostics and
   point at the wrong code.
3. **Find the line:**
   - App freezes / UI stalls: `dotnet-trace collect --process-id <PID>`
   - Memory growth / leaks: `dotnet-dump collect --process-id <PID>`
   - Rendering hitches: Inspect Composition Frame rates.
4. **Fix with the matching recipe.**
5. **Measure again.** Put before and after in the commit message:
   "List filter opens in 25 ms, was 420 ms".

## The rules that fix most problems

- **UI thread does UI only.** File I/O, database queries, image decoding,
  and OCR must run in background threads (`Task.Run`).
- **Show first, work after.** Put the window or panel on screen in the same
  frame as the key press, then load. Never make the UI wait for the work.
- **Virtualize large lists.** Use `ListView` with item virtualization or
  `ItemsRepeater` so off-screen elements are not instantiated.
- **Decode at display size.** Decode images at the exact dimensions they will
  render at on screen.
- **No polling without reason.** Use event-driven APIs (e.g., `AddClipboardFormatListener`)
  instead of `DispatcherTimer` polling loops.

## Done when

UI thread bottlenecks are profiled, memory allocations are reduced, and the app sustains 60 FPS without frame drops.
