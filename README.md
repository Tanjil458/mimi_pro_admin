# mimi_pro_admin

This project uses a persistent layout shell (`MainLayout`) that contains a
header (`AppBar`), a side `Drawer`, and a `BottomNavigationBar`. Only the
body content changes when the user switches pages; the layout elements remain
constant. Navigation is index-based and handled by an `IndexedStack` to
preserve state.

## Adding a new page

1. Create a new Dart file under `lib/pages/` defining your page widget. **Do
   not** include a `Scaffold` in the page itself.
2. Register the page by adding a new `PageItem` entry in
   `lib/page_config.dart` with a title, icon, and widget instance.
   - The `title` will be shown in the app bar and navigation components.
   - The order in the list determines the index used for navigation.

The layout and navigation logic are entirely centralized; no duplication of
Scaffold or app‑bar code is necessary when creating additional pages.


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
