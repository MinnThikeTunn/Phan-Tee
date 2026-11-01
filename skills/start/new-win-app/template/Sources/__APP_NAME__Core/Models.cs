namespace __APP_NAME__Core;

/// <summary>
/// Core database entity for an item.
/// Uses stable Guid identifiers so lookups and selections survive saves.
/// </summary>
public class Item
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public string Title { get; set; } = string.Empty;
    public string? Notes { get; set; }
    public bool IsStarred { get; set; }
    public DateTimeOffset CreatedAt { get; set; } = DateTimeOffset.UtcNow;
    public DateTimeOffset? CompletedAt { get; set; }

    public bool IsCompleted => CompletedAt.HasValue;

    public void ToggleComplete()
    {
        CompletedAt = CompletedAt.HasValue ? null : DateTimeOffset.UtcNow;
    }
}
