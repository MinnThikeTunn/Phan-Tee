using System.Collections.ObjectModel;
using CommunityToolkit.Mvvm.ComponentModel;
using CommunityToolkit.Mvvm.Input;
using Microsoft.EntityFrameworkCore;
using __APP_NAME__Core;

namespace __APP_NAME__;

public enum SidebarItem
{
    All,
    Starred,
    Completed
}

public enum SettingsTab
{
    General,
    Appearance,
    About
}

public partial class AppModel : ObservableObject
{
    [ObservableProperty]
    private SidebarItem _selectedPage = SidebarItem.All;

    [ObservableProperty]
    private Item? _selectedItem;

    [ObservableProperty]
    private SettingsTab _selectedSettingsTab = SettingsTab.General;

    public ObservableCollection<Item> Items { get; } = new();

    public AppModel()
    {
        RefreshItems();
    }

    public void RefreshItems()
    {
        using var db = new AppDbContext();
        var query = db.Items.AsNoTracking().OrderByDescending(x => x.CreatedAt);

        var list = SelectedPage switch
        {
            SidebarItem.Starred => query.Where(x => x.IsStarred).ToList(),
            SidebarItem.Completed => query.Where(x => x.CompletedAt != null).ToList(),
            _ => query.ToList()
        };

        Items.Clear();
        foreach (var item in list)
        {
            Items.Add(item);
        }

        if (SelectedItem == null || !Items.Any(x => x.Id == SelectedItem.Id))
        {
            SelectedItem = Items.FirstOrDefault();
        }
    }

    [RelayCommand]
    public void AddItem(string? title = null)
    {
        var finalTitle = ItemTitle.Sanitize(title);
        if (string.IsNullOrEmpty(finalTitle))
        {
            finalTitle = "New Task";
        }

        var item = new Item
        {
            Title = finalTitle,
            CreatedAt = DateTimeOffset.UtcNow
        };

        using (var db = new AppDbContext())
        {
            db.Items.Add(item);
            db.SaveChanges();
        }

        RefreshItems();
        SelectedItem = Items.FirstOrDefault(x => x.Id == item.Id);
    }

    [RelayCommand]
    public void DeleteItem(Item? item)
    {
        if (item == null) return;

        using (var db = new AppDbContext())
        {
            var existing = db.Items.Find(item.Id);
            if (existing != null)
            {
                db.Items.Remove(existing);
                db.SaveChanges();
            }
        }

        RefreshItems();
    }

    [RelayCommand]
    public void ToggleStar(Item? item)
    {
        if (item == null) return;

        using (var db = new AppDbContext())
        {
            var existing = db.Items.Find(item.Id);
            if (existing != null)
            {
                existing.IsStarred = !existing.IsStarred;
                db.SaveChanges();
            }
        }

        RefreshItems();
    }
}
