using Microsoft.UI.Composition.SystemBackdrops;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Media;
using Windows.UI.ViewManagement;

namespace __APP_NAME__.UI;

public static class Theme
{
    private static readonly UISettings _uiSettings = new();

    public static Windows.UI.Color GetSystemAccentColor()
    {
        return _uiSettings.GetColorValue(UIColorType.Accent);
    }

    public static void ApplyMicaBackdrop(Window window)
    {
        if (MicaController.IsSupported())
        {
            window.SystemBackdrop = new MicaBackdrop
            {
                Kind = MicaKind.BaseAlt
            };
        }
    }
}
