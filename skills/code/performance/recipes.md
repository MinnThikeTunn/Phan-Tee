# Performance Recipes for Windows Apps

## 1. UI Virtualization for Large Collections

Ensure `ListView` recycles containers rather than allocating a visual tree per item:

```xml
<ListView
    ItemsSource="{x:Bind ViewModel.LargeItemsList}"
    ScrollViewer.VerticalScrollBarVisibility="Auto"
    ScrollViewer.IsVerticalScrollChainingEnabled="False">
    <ListView.ItemsPanel>
        <ItemsPanelTemplate>
            <ItemsStackPanel />
        </ItemsPanelTemplate>
    </ListView.ItemsPanel>
</ListView>
```

---

## 2. Background Task with DispatcherQueue

Offload heavy calculations and update UI cleanly:

```csharp
public async Task ProcessDataAsync(byte[] rawData, Microsoft.UI.Dispatching.DispatcherQueue dispatcher)
{
    // Heavy background parsing
    var result = await Task.Run(() =>
    {
        return HeavyParser.Parse(rawData);
    });

    // Hop back to UI thread
    dispatcher.TryEnqueue(() =>
    {
        ViewModel.UpdateResult(result);
    });
}
```

---

## 3. High-Performance SQLite WAL Batching

Wrap bulk database operations in a single transaction:

```csharp
using var db = new AppDbContext();
using var transaction = db.Database.BeginTransaction();

db.Items.AddRange(newItems);
db.SaveChanges();

transaction.Commit();
```
