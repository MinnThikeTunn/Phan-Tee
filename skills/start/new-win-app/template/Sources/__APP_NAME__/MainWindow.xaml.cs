using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using __APP_NAME__.UI;

namespace __APP_NAME__;

public sealed partial class MainWindow : Window
{
    public AppModel ViewModel { get; } = new();

    public MainWindow()
    {
        this.InitializeComponent();

        Theme.ApplyMicaBackdrop(this);
        WindowBehavior.InitializeWindow(this);

        this.SetTitleBar(AppTitleBar);

        NavView.SelectedItem = NavView.MenuItems[0];
        ContentFrame.Navigate(typeof(ContentView), ViewModel);
    }

    private void NavView_SelectionChanged(NavigationView sender, NavigationViewSelectionChangedEventArgs args)
    {
        if (args.IsSettingsSelected)
        {
            ContentFrame.Navigate(typeof(SettingsView), ViewModel);
        }
        else if (args.SelectedItemContainer is NavigationViewItem item && item.Tag is string tag)
        {
            if (Enum.TryParse<SidebarItem>(tag, out var page))
            {
                ViewModel.SelectedPage = page;
                ViewModel.RefreshItems();
                ContentFrame.Navigate(typeof(ContentView), ViewModel);
            }
        }
    }
}
