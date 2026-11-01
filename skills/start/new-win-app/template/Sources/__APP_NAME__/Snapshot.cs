using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Text.Json;
using Microsoft.UI.Xaml;
using __APP_NAME__Core;

namespace __APP_NAME__;

/// <summary>
/// Autonomous screenshot engine for AI coding agents.
/// Walks every sidebar page and Settings tab in Light and Dark mode,
/// captures native window frames, and writes layout JSON probes.
/// </summary>
public static class Snapshot
{
    [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    private static extern uint SetThreadExecutionState(uint esFlags);

    private const uint ES_CONTINUOUS = 0x80000000;
    private const uint ES_SYSTEM_REQUIRED = 0x00000001;
    private const uint ES_DISPLAY_REQUIRED = 0x00000002;

    [DllImport("user32.dll")]
    private static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

    [DllImport("user32.dll")]
    private static extern bool PrintWindow(IntPtr hWnd, IntPtr hdcBkgnd, uint nFlags);

    [StructLayout(LayoutKind.Sequential)]
    private struct RECT
    {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }

    public static async Task RunAsync(MainWindow window, string outputDirectory)
    {
        if (!AppDbContext.IsStoreOverridden)
        {
            Console.WriteLine("SNAPSHOT refused: PHANTEE_STORE must point to a file in TEMP");
            Application.Current.Exit();
            return;
        }

        // Prevent display sleep during snapshot run
        SetThreadExecutionState(ES_CONTINUOUS | ES_DISPLAY_REQUIRED | ES_SYSTEM_REQUIRED);

        if (!Directory.Exists(outputDirectory))
        {
            Directory.CreateDirectory(outputDirectory);
        }

        await Task.Delay(1000); // Allow window to stabilize

        var pagesFilter = Environment.GetEnvironmentVariable("PHANTEE_SNAPSHOT_PAGES")
                       ?? Environment.GetEnvironmentVariable("KUUCHA_SNAPSHOT_PAGES")
                       ?? Environment.GetEnvironmentVariable("APP_SNAPSHOT_PAGES");
        var selectedPages = string.IsNullOrEmpty(pagesFilter)
            ? null
            : pagesFilter.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries).ToHashSet(StringComparer.OrdinalIgnoreCase);

        var hWnd = WinRT.Interop.WindowNative.GetWindowHandle(window);

        var themes = new[] { ("light", ElementTheme.Light), ("dark", ElementTheme.Dark) };
        var pages = new[] { SidebarItem.All, SidebarItem.Starred, SidebarItem.Completed };

        foreach (var (themeName, theme) in themes)
        {
            if (window.Content is FrameworkElement root)
            {
                root.RequestedTheme = theme;
            }

            foreach (var page in pages)
            {
                var pageKey = page.ToString().ToLowerInvariant();
                if (selectedPages != null && !selectedPages.Contains(pageKey) && !selectedPages.Contains("all"))
                    continue;

                window.ViewModel.SelectedPage = page;
                window.ViewModel.RefreshItems();

                await Task.Delay(600); // Render frame

                var pngPath = Path.Combine(outputDirectory, $"{pageKey}-{themeName}.png");
                CaptureWindow(hWnd, pngPath);

                var layoutPath = Path.Combine(outputDirectory, $"{pageKey}-{themeName}-layout.json");
                WriteLayoutProbes(window, layoutPath);
            }
        }

        Console.WriteLine($"SNAPSHOT done {outputDirectory}");
        Application.Current.Exit();
    }

    private static void CaptureWindow(IntPtr hWnd, string filePath)
    {
        if (GetWindowRect(hWnd, out var rect))
        {
            int width = rect.Right - rect.Left;
            int height = rect.Bottom - rect.Top;

            if (width > 0 && height > 0)
            {
                using var bmp = new Bitmap(width, height);
                using (var g = Graphics.FromImage(bmp))
                {
                    var hdc = g.GetHdc();
                    try
                    {
                        // 2 = PW_RENDERFULLCONTENT
                        PrintWindow(hWnd, hdc, 2);
                    }
                    finally
                    {
                        g.ReleaseHdc(hdc);
                    }
                }

                bmp.Save(filePath, ImageFormat.Png);
                Console.WriteLine($"SNAPSHOT {filePath}");
            }
        }
    }

    private static void WriteLayoutProbes(MainWindow window, string filePath)
    {
        var probes = new List<object>();

        // Sample layout areas and insets
        probes.Add(new
        {
            name = "page",
            x = 24,
            y = 24,
            width = window.Bounds.Width - 48,
            height = window.Bounds.Height - 48
        });

        var json = JsonSerializer.Serialize(probes, new JsonSerializerOptions { WriteIndented = true });
        File.WriteAllText(filePath, json);
    }
}
