using Microsoft.UI;
using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Windows.Graphics;

namespace __APP_NAME__.UI;

public static class WindowBehavior
{
    public static void InitializeWindow(Window window, int defaultWidth = 1100, int defaultHeight = 720)
    {
        var hWnd = WinRT.Interop.WindowNative.GetWindowHandle(window);
        var windowId = Win32Interop.GetWindowIdFromWindow(hWnd);
        var appWindow = AppWindow.GetFromWindowId(windowId);

        if (appWindow != null)
        {
            appWindow.Resize(new SizeInt32(defaultWidth, defaultHeight));

            // Center window on screen
            var displayArea = DisplayArea.GetFromWindowId(windowId, DisplayAreaFallback.Primary);
            if (displayArea != null)
            {
                var centeredPosition = new PointInt32(
                    (displayArea.WorkArea.Width - defaultWidth) / 2,
                    (displayArea.WorkArea.Height - defaultHeight) / 2
                );
                appWindow.Move(centeredPosition);
            }

            // Extend content into title bar for modern Fluent look
            appWindow.TitleBar.ExtendsContentIntoTitleBar = true;
            appWindow.TitleBar.ButtonBackgroundColor = Colors.Transparent;
            appWindow.TitleBar.ButtonInactiveBackgroundColor = Colors.Transparent;
        }
    }
}
