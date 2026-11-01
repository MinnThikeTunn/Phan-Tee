# Architecture Reference for Phan-Tee Windows Apps

## 1. Deep vs. Shallow Modules
- **Deep modules:** Simple public interface (`ItemManager.ProcessBatch()`), hiding database transactions, sanitization, validation, and notification caching internally.
- **Shallow modules:** Unnecessary helper classes that simply wrap another class's method without adding value. Avoid them.

## 2. Decoupling Rules
- `<AppName>Core` MUST NOT reference any WinUI 3, XAML, or Windowing packages.
- All domain rules, parsers, formatters, and EF Core models belong in `<AppName>Core`.
- ViewModels in `<AppName>` orchestrate UI state and delegate mutations to `<AppName>Core`.
