using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Navigation;
using __APP_NAME__Core;

namespace __APP_NAME__;

public sealed partial class ContentView : Page
{
    public AppModel ViewModel { get; private set; } = null!;

    public ContentView()
    {
        this.InitializeComponent();
    }

    protected override void OnNavigatedTo(NavigationEventArgs e)
    {
        if (e.Parameter is AppModel model)
        {
            ViewModel = model;
            UpdateDetailView();
        }
    }

    private void NewItem_Click(object sender, RoutedEventArgs e)
    {
        ViewModel.AddItem("New Task");
        UpdateDetailView();
    }

    private void StarItem_Click(object sender, RoutedEventArgs e)
    {
        ViewModel.ToggleStar(ViewModel.SelectedItem);
    }

    private void DeleteItem_Click(object sender, RoutedEventArgs e)
    {
        ViewModel.DeleteItem(ViewModel.SelectedItem);
        UpdateDetailView();
    }

    private void ItemsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        UpdateDetailView();
    }

    private void UpdateDetailView()
    {
        if (ViewModel?.SelectedItem != null)
        {
            DetailPane.Visibility = Visibility.Visible;
            EmptyDetailPlaceholder.Visibility = Visibility.Collapsed;

            TitleEditor.Text = ViewModel.SelectedItem.Title;
            NotesEditor.Text = ViewModel.SelectedItem.Notes ?? string.Empty;
            CompletedCheckBox.IsChecked = ViewModel.SelectedItem.IsCompleted;
        }
        else
        {
            DetailPane.Visibility = Visibility.Collapsed;
            EmptyDetailPlaceholder.Visibility = Visibility.Visible;
        }
    }

    private void TitleEditor_TextChanged(object sender, TextChangedEventArgs e)
    {
        if (ViewModel?.SelectedItem != null)
        {
            ViewModel.SelectedItem.Title = TitleEditor.Text;
            using var db = new AppDbContext();
            var item = db.Items.Find(ViewModel.SelectedItem.Id);
            if (item != null)
            {
                item.Title = TitleEditor.Text;
                db.SaveChanges();
            }
        }
    }

    private void CompletedCheckBox_Click(object sender, RoutedEventArgs e)
    {
        if (ViewModel?.SelectedItem != null)
        {
            ViewModel.SelectedItem.ToggleComplete();
            using var db = new AppDbContext();
            var item = db.Items.Find(ViewModel.SelectedItem.Id);
            if (item != null)
            {
                item.CompletedAt = ViewModel.SelectedItem.CompletedAt;
                db.SaveChanges();
            }
        }
    }
}
