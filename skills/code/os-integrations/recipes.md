# Windows Integration Recipes

Copyable C# recipes for deep Windows integrations with zero administrative privilege requirements.

---

## 1. Global Hotkey (Win32 RegisterHotKey)

Registers a system-wide hotkey (e.g. `Ctrl+Alt+Space`):

```csharp
using System.Runtime.InteropServices;

public class GlobalHotkeyManager
{
    [DllImport("user32.dll")]
    private static extern bool RegisterHotKey(IntPtr hWnd, int id, uint fsModifiers, uint vk);

    [DllImport("user32.dll")]
    private static extern bool UnregisterHotKey(IntPtr hWnd, int id);

    public const uint MOD_ALT = 0x0001;
    public const uint MOD_CONTROL = 0x0002;
    public const uint MOD_SHIFT = 0x0004;
    public const uint MOD_NOREPEAT = 0x4000;

    public static bool Register(IntPtr hWnd, int hotkeyId, uint modifiers, uint vk)
    {
        return RegisterHotKey(hWnd, hotkeyId, modifiers | MOD_NOREPEAT, vk);
    }

    public static void Unregister(IntPtr hWnd, int hotkeyId)
    {
        UnregisterHotKey(hWnd, hotkeyId);
    }
}
```

---

## 2. Window Manipulation & Snapping (Win32 SetWindowPos)

Moves and snaps external application windows (e.g., for a window snapper utility):

```csharp
using System.Runtime.InteropServices;

public class WindowManager
{
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

    public const uint SWP_NOZORDER = 0x0004;
    public const uint SWP_SHOWWINDOW = 0x0040;

    public static void SnapLeft(IntPtr hWnd, int screenWidth, int screenHeight)
    {
        SetWindowPos(hWnd, IntPtr.Zero, 0, 0, screenWidth / 2, screenHeight, SWP_NOZORDER | SWP_SHOWWINDOW);
    }

    public static void SnapRight(IntPtr hWnd, int screenWidth, int screenHeight)
    {
        SetWindowPos(hWnd, IntPtr.Zero, screenWidth / 2, 0, screenWidth / 2, screenHeight, SWP_NOZORDER | SWP_SHOWWINDOW);
    }
}
```

---

## 3. Clipboard History Listener (Win32 AddClipboardFormatListener)

Listens for any clipboard change system-wide without CPU-polling:

```csharp
using System.Runtime.InteropServices;

public class ClipboardListener
{
    [DllImport("user32.dll")]
    public static extern bool AddClipboardFormatListener(IntPtr hWnd);

    [DllImport("user32.dll")]
    public static extern bool RemoveClipboardFormatListener(IntPtr hWnd);

    public const int WM_CLIPBOARDUPDATE = 0x031D;

    // Inside window message handler:
    // if (msg == WM_CLIPBOARDUPDATE) { OnClipboardChanged(); }
}
```

---

## 4. Prevent Display Sleep (Win32 SetThreadExecutionState)

Keeps screen and system awake (for presentations, timers, long renders):

```csharp
using System.Runtime.InteropServices;

public static class PowerControl
{
    [DllImport("kernel32.dll")]
    private static extern uint SetThreadExecutionState(uint esFlags);

    private const uint ES_CONTINUOUS = 0x80000000;
    private const uint ES_SYSTEM_REQUIRED = 0x00000001;
    private const uint ES_DISPLAY_REQUIRED = 0x00000002;

    public static void PreventSleep()
    {
        SetThreadExecutionState(ES_CONTINUOUS | ES_DISPLAY_REQUIRED | ES_SYSTEM_REQUIRED);
    }

    public static void AllowSleep()
    {
        SetThreadExecutionState(ES_CONTINUOUS);
    }
}
```

---

## 5. Launch at Windows Startup (Current User Registry)

Registers the app to start automatically upon user login:

```csharp
using Microsoft.Win32;

public static class StartupManager
{
    private const string RunKey = @"Software\Microsoft\Windows\CurrentVersion\Run";

    public static void SetStartup(string appName, string executablePath, bool enable)
    {
        using var key = Registry.CurrentUser.OpenSubKey(RunKey, writable: true);
        if (key == null) return;

        if (enable)
        {
            key.SetValue(appName, $"\"{executablePath}\"");
        }
        else
        {
            key.DeleteValue(appName, throwOnMissingValue: false);
        }
    }
}
```

---

## 6. On-Device OCR Text Recognition (WinRT OcrEngine)

Extracts text from images using Windows built-in local offline OCR:

```csharp
using Windows.Graphics.Imaging;
using Windows.Media.Ocr;

public static class LocalOcr
{
    public static async Task<string> RecognizeTextAsync(SoftwareBitmap bitmap)
    {
        var ocrEngine = OcrEngine.TryCreateFromUserProfileLanguages();
        if (ocrEngine == null) return string.Empty;

        var ocrResult = await ocrEngine.RecognizeAsync(bitmap);
        return ocrResult.Text;
    }
}
```
