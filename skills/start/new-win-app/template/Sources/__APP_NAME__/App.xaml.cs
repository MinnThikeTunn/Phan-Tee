using Microsoft.UI.Xaml;
using System.Diagnostics;
using __APP_NAME__Core;

namespace __APP_NAME__;

/// <summary>
/// __APP_NAME__
///   __APP_NAME__.exe                        normal launch
///   PHANTEE_STORE=<file> __APP_NAME__.exe   isolated database (tests, experiments)
///   PHANTEE_SNAPSHOT=<dir> __APP_NAME__.exe take light/dark PNGs of all pages, then quit
///   PHANTEE_SEED=1 __APP_NAME__.exe         fill empty database with sample items
///   __APP_NAME__.exe --selftest             run self-test and exit 0 or 1
///   PHANTEE_GRID=1 __APP_NAME__.exe         render layout probe debug overlays
/// </summary>
public partial class App : Application
{
    public static MainWindow? MainWindowInstance { get; private set; }

    public App()
    {
        this.InitializeComponent();
    }

    protected override async void OnLaunched(LaunchActivatedEventArgs args)
    {
        // Intercept --selftest before rendering any window
        var commandArgs = Environment.GetCommandLineArgs();
        if (commandArgs.Contains("--selftest"))
        {
            var exitCode = await SelfTest.RunAsync();
            Environment.Exit(exitCode);
            return;
        }

        // Initialize local SQLite database
        using (var db = AppDbContext.CreateAndInitialize())
        {
            if (Environment.GetEnvironmentVariable("PHANTEE_SEED") == "1" ||
                Environment.GetEnvironmentVariable("KUUCHA_SEED") == "1" ||
                Environment.GetEnvironmentVariable("APP_SEED") == "1")
            {
                SeedData.InsertIfEmpty(db);
            }
        }

        MainWindowInstance = new MainWindow();
        MainWindowInstance.Activate();

        // Check for snapshot mode
        var snapshotDir = Environment.GetEnvironmentVariable("PHANTEE_SNAPSHOT")
                       ?? Environment.GetEnvironmentVariable("KUUCHA_SNAPSHOT")
                       ?? Environment.GetEnvironmentVariable("APP_SNAPSHOT");

        if (!string.IsNullOrEmpty(snapshotDir))
        {
            await Snapshot.RunAsync(MainWindowInstance, snapshotDir);
        }
    }
}
