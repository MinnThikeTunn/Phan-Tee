using __APP_NAME__Core;

namespace __APP_NAME__;

/// <summary>
/// Seed data injected when running tests or snapshot mode (PHANTEE_SEED=1).
/// Guarantees that snapshots show realistic populated states.
/// </summary>
public static class SeedData
{
    public static void InsertIfEmpty(AppDbContext db)
    {
        if (db.Items.Any()) return;

        var sampleItems = new[]
        {
            new Item
            {
                Title = "Review Windows 11 Fluent guidelines",
                Notes = "Check Mica backdrop and Segoe UI Variable typography scales.",
                IsStarred = true,
                CreatedAt = DateTimeOffset.UtcNow.AddHours(-2)
            },
            new Item
            {
                Title = "Audit keyboard shortcuts in CommandBar",
                Notes = "Ensure Alt+N and Ctrl+F work across all pages.",
                IsStarred = true,
                CreatedAt = DateTimeOffset.UtcNow.AddHours(-5)
            },
            new Item
            {
                Title = "Capture light and dark window snapshots",
                Notes = "Run tools/snap.ps1 to verify layout bounds.",
                IsStarred = false,
                CreatedAt = DateTimeOffset.UtcNow.AddDays(-1)
            },
            new Item
            {
                Title = "Verify offline SQLite database integrity",
                Notes = "WAL mode enabled with zero external network calls.",
                IsStarred = false,
                CreatedAt = DateTimeOffset.UtcNow.AddDays(-2),
                CompletedAt = DateTimeOffset.UtcNow.AddDays(-1)
            }
        };

        db.Items.AddRange(sampleItems);
        db.SaveChanges();
    }
}
