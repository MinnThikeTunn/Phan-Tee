namespace __APP_NAME__Core;

/// <summary>
/// Domain validation and formatting rules for item titles.
/// Pure C# with zero UI dependencies, allowing instant unit testing.
/// </summary>
public static class ItemTitle
{
    public static string Sanitize(string? raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
            return string.Empty;

        return raw.Trim();
    }

    public static bool IsValid(string? title)
    {
        var sanitized = Sanitize(title);
        return !string.IsNullOrEmpty(sanitized) && sanitized.Length <= 250;
    }
}
