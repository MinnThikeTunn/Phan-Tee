using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;
using __APP_NAME__Core;

namespace __APP_NAME__;

public sealed partial class SettingsView : Page
{
    public SettingsView()
    {
        this.InitializeComponent();
        DatabasePathText.Text = $"Database: {AppDbContext.GetDatabasePath()}";
    }

    private void ThemeRadioButtons_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (ThemeRadioButtons.SelectedItem is RadioButton rb && rb.Tag is string tag)
        {
            if (App.MainWindowInstance?.Content is FrameworkElement root)
            {
                root.RequestedTheme = tag switch
                {
                    "Light" => ElementTheme.Light,
                    "Dark" => ElementTheme.Dark,
                    _ => ElementTheme.Default
                };
            }
        }
    }
}
