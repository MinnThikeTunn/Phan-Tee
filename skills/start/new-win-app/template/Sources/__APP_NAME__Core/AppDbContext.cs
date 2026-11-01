using Microsoft.EntityFrameworkCore;

namespace __APP_NAME__Core;

/// <summary>
/// EF Core SQLite database context.
/// Supports deterministic store redirection via PHANTEE_STORE or APP_STORE
/// for snapshot and self-test isolation.
/// </summary>
public class AppDbContext : DbContext
{
    public DbSet<Item> Items => Set<Item>();

    public AppDbContext()
    {
    }

    public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
    {
    }

    public static string GetDatabasePath()
    {
        var overridePath = Environment.GetEnvironmentVariable("PHANTEE_STORE")
                        ?? Environment.GetEnvironmentVariable("KUUCHA_STORE")
                        ?? Environment.GetEnvironmentVariable("APP_STORE");

        if (!string.IsNullOrWhiteSpace(overridePath))
        {
            var dir = Path.GetDirectoryName(overridePath);
            if (!string.IsNullOrEmpty(dir) && !Directory.Exists(dir))
            {
                Directory.CreateDirectory(dir);
            }
            return overridePath;
        }

        var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var appFolder = Path.Combine(localAppData, "__APP_NAME__");
        if (!Directory.Exists(appFolder))
        {
            Directory.CreateDirectory(appFolder);
        }

        return Path.Combine(appFolder, "__APP_NAME__.db");
    }

    public static bool IsStoreOverridden =>
        !string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("PHANTEE_STORE")) ||
        !string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("KUUCHA_STORE")) ||
        !string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("APP_STORE"));

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        if (!optionsBuilder.IsConfigured)
        {
            var dbPath = GetDatabasePath();
            optionsBuilder.UseSqlite($"Data Source={dbPath}");
        }
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Item>(entity =>
        {
            entity.HasKey(e => e.Id);
            entity.Property(e => e.Title).IsRequired().HasMaxLength(250);
            entity.HasIndex(e => e.CreatedAt);
            entity.HasIndex(e => e.IsStarred);
        });
    }

    /// <summary>
    /// Creates and migrates/initializes the database with WAL mode enabled.
    /// </summary>
    public static AppDbContext CreateAndInitialize()
    {
        var context = new AppDbContext();
        context.Database.EnsureCreated();

        // Enable Write-Ahead Logging for high-concurrency desktop performance
        context.Database.ExecuteSqlRaw("PRAGMA journal_mode=WAL;");
        return context;
    }
}
