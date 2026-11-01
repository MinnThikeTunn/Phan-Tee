using Microsoft.UI.Xaml;

namespace __APP_NAME__.UI;

/// <summary>
/// 4 px / 8 px layout grid spacing scale for Windows 11 apps.
/// Raw numbers should be 0, 1, 2, or multiples of 4.
/// </summary>
public static class Space
{
    public const double Xs = 4.0;
    public const double Sm = 8.0;
    public const double Md = 12.0;
    public const double Lg = 16.0;
    public const double Xl = 20.0;
    public const double Xxl = 24.0;
    public const double Section = 32.0;
    public const double Margin = 24.0;
}

/// <summary>
/// Attached properties to probe layout elements in snapshot mode
/// and verify grid compliance.
/// </summary>
public static class GridProbe
{
    public static readonly DependencyProperty AreaProperty =
        DependencyProperty.RegisterAttached("Area", typeof(string), typeof(GridProbe), new PropertyMetadata(null));

    public static string? GetArea(DependencyObject obj) => (string?)obj.GetValue(AreaProperty);
    public static void SetArea(DependencyObject obj, string? value) => obj.SetValue(AreaProperty, value);

    public static readonly DependencyProperty NameProperty =
        DependencyProperty.RegisterAttached("Name", typeof(string), typeof(GridProbe), new PropertyMetadata(null));

    public static string? GetName(DependencyObject obj) => (string?)obj.GetValue(NameProperty);
    public static void SetName(DependencyObject obj, string? value) => obj.SetValue(NameProperty, value);

    public static readonly DependencyProperty EdgeProperty =
        DependencyProperty.RegisterAttached("Edge", typeof(string), typeof(GridProbe), new PropertyMetadata("lead"));

    public static string? GetEdge(DependencyObject obj) => (string?)obj.GetValue(EdgeProperty);
    public static void SetEdge(DependencyObject obj, string? value) => obj.SetValue(EdgeProperty, value);
}
