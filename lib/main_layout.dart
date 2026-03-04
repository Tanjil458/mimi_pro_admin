import 'package:flutter/material.dart';
import 'page_config.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  int _lastBottomIndex = 0; // remembers the last active bottom-nav tab
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _selectPage(int index) {
    if (index < 0 || index >= pageItems.length) return;

    // only close the drawer if it is currently open
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }

    setState(() {
      _currentIndex = index;
    });
  }

  // pages that appear in the bottom navigation bar
  List<PageItem> get _bottomPages =>
      pageItems.where((p) => p.showInBottomNav).toList();

  // pages that appear in the drawer; we deliberately exclude any item that
  // also exists in the bottom bar to prevent duplication between the two
  // navigators.
  List<PageItem> get _drawerPages =>
      pageItems.where((p) => !p.showInBottomNav).toList();

  int get _currentBottomIndex {
    final current = pageItems[_currentIndex];
    return _bottomPages.indexOf(current);
  }

  void _onBottomTap(int bottomIndex) {
    if (bottomIndex < 0 || bottomIndex >= _bottomPages.length) return;

    _lastBottomIndex = bottomIndex;
    final targetPage = _bottomPages[bottomIndex];
    final pageIndex = pageItems.indexOf(targetPage);
    _selectPage(pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = pageItems[_currentIndex];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(currentPage.title)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF1C3A5E)),
              child: Text(
                'Navigation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            // only show entries that aren’t also in the bottom bar
            for (var page in _drawerPages)
              ListTile(
                leading: Icon(page.icon),
                title: Text(page.title),
                selected: pageItems.indexOf(page) == _currentIndex,
                onTap: () {
                  final idx = pageItems.indexOf(page);
                  _selectPage(idx);
                },
              ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pageItems.map((p) => p.widget).toList(),
      ),
      // Always show the bottom nav bar so users can return to a main page
      // even when a drawer-only page is active.
      bottomNavigationBar: _bottomPages.length >= 2
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF1C3A5E),
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              elevation: 8,
              currentIndex: currentPage.showInBottomNav
                  ? _currentBottomIndex.clamp(0, _bottomPages.length - 1)
                  : _lastBottomIndex,
              onTap: _onBottomTap,
              items: _bottomPages
                  .map(
                    (p) => BottomNavigationBarItem(
                      icon: Icon(p.icon),
                      label: p.title,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}
