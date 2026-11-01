# Windows Accessibility Guidelines

1. **AutomationProperties:** Set `AutomationProperties.Name` on icon-only buttons:
   ```xml
   <Button AutomationProperties.Name="Delete item">
       <FontIcon Glyph="&#xE107;" />
   </Button>
   ```
2. **Keyboard Focus:** Every interactive control must be focusable via Tab and show the standard Windows 11 focus visual.
3. **High Contrast:** All custom brushes must respond to Windows High Contrast mode (`SystemColor...` tokens).
