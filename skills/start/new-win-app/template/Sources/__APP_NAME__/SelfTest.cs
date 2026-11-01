using __APP_NAME__Core;

namespace __APP_NAME__;

/// <summary>
/// Headless functional self-test harness.
/// Invoked via --selftest flag from tools/selftest.ps1.
/// Runs actual domain functions on a temporary store and exits with 0 or 1.
/// </summary>
public static class SelfTest
{
    public static async Task<int> RunAsync()
    {
        Console.WriteLine("Running self-test...");

        // Safety check: Never run against real user data
        if (!AppDbContext.IsStoreOverridden)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("SELFTEST refused: PHANTEE_STORE must point to a file in TEMP");
            Console.ResetColor();
            return 1;
        }

        try
        {
            using var db = AppDbContext.CreateAndInitialize();

            // Check 1: Insert item
            var testItem = new Item { Title = "SelfTest Task" };
            db.Items.Add(testItem);
            db.SaveChanges();
            Console.WriteLine("PASS insert item");

            // Check 2: Query item
            var fetched = db.Items.Find(testItem.Id);
            if (fetched == null || fetched.Title != "SelfTest Task")
            {
                throw new InvalidOperationException("Failed to query inserted item");
            }
            Console.WriteLine("PASS query item");

            // Check 3: Star item
            fetched.IsStarred = true;
            db.SaveChanges();
            var starred = db.Items.Find(testItem.Id);
            if (starred == null || !starred.IsStarred)
            {
                throw new InvalidOperationException("Failed to update item starred state");
            }
            Console.WriteLine("PASS star item");

            // Check 4: Toggle complete
            starred.ToggleComplete();
            db.SaveChanges();
            if (!starred.IsCompleted)
            {
                throw new InvalidOperationException("Failed to mark item completed");
            }
            Console.WriteLine("PASS complete item");

            // Check 5: Delete item
            db.Items.Remove(starred);
            db.SaveChanges();
            if (db.Items.Any(x => x.Id == testItem.Id))
            {
                throw new InvalidOperationException("Failed to remove item");
            }
            Console.WriteLine("PASS delete item");

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("PASS all self-test checks passed");
            Console.ResetColor();
            return 0;
        }
        catch (Exception ex)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine($"FAIL selftest error: {ex.Message}");
            Console.ResetColor();
            return 1;
        }
    }
}
