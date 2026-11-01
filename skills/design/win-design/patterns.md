# Fluent XAML Patterns

## 1. Card Container with Subtle Stroke
```xml
<Border
    Background="{ThemeResource CardBackgroundFillColorDefaultBrush}"
    BorderBrush="{ThemeResource CardStrokeColorDefaultBrush}"
    BorderThickness="1"
    CornerRadius="8"
    Padding="16">
    <StackPanel Spacing="8">
        <TextBlock Text="Card Title" FontWeight="SemiBold" />
        <TextBlock Text="Card body content..." Foreground="{ThemeResource TextFillColorSecondaryBrush}" />
    </StackPanel>
</Border>
```

## 2. CommandBar with Primary and Secondary Actions
```xml
<CommandBar Background="Transparent" IsOpen="False" DefaultLabelPosition="Right">
    <AppBarButton Icon="Add" Label="Add Item">
        <AppBarButton.KeyboardAccelerators>
            <KeyboardAccelerator Key="N" Modifiers="Control" />
        </AppBarButton.KeyboardAccelerators>
    </AppBarButton>
    <AppBarSeparator />
    <AppBarButton Icon="Delete" Label="Delete" />
</CommandBar>
```
