# Windows 11 Design Checklist

- [ ] Window extends into title bar (`appWindow.TitleBar.ExtendsContentIntoTitleBar = true`).
- [ ] Mica backdrop enabled on main window.
- [ ] Accent color follows Windows Personalization (`ThemeResource AccentFillColorDefaultBrush`).
- [ ] Primary buttons use `Style="{StaticResource AccentButtonStyle}"`.
- [ ] Spacing adheres to 4 px / 8 px scale: 24 px page margin, 16 px card padding, 8 px between related controls.
- [ ] All icon buttons have `AutomationProperties.Name` and keyboard shortcuts.
- [ ] Empty pages display an illustration or icon with an action button.
