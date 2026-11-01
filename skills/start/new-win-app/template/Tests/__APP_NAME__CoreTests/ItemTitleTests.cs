using Xunit;
using __APP_NAME__Core;

namespace __APP_NAME__CoreTests;

public class ItemTitleTests
{
    [Theory]
    [InlineData("  Buy groceries  ", "Buy groceries")]
    [InlineData("Clean desk\n", "Clean desk")]
    [InlineData(null, "")]
    [InlineData("   ", "")]
    public void Sanitize_TrimsWhitespace(string? input, string expected)
    {
        var result = ItemTitle.Sanitize(input);
        Assert.Equal(expected, result);
    }

    [Theory]
    [InlineData("Valid Title", true)]
    [InlineData("", false)]
    [InlineData("   ", false)]
    [InlineData(null, false)]
    public void IsValid_DetectsEmptyTitles(string? input, bool expected)
    {
        var result = ItemTitle.IsValid(input);
        Assert.Equal(expected, result);
    }

    [Fact]
    public void Item_ToggleComplete_SetsAndClearsTimestamp()
    {
        var item = new Item { Title = "Test Task" };
        Assert.False(item.IsCompleted);

        item.ToggleComplete();
        Assert.True(item.IsCompleted);
        Assert.NotNull(item.CompletedAt);

        item.ToggleComplete();
        Assert.False(item.IsCompleted);
        Assert.Null(item.CompletedAt);
    }
}
