import 'package:flutter/material.dart';
import 'page_config.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
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
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
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
      // only show a BottomNavigationBar when the current page wants it *and*
      // there are at least two entries.  Flutter asserts otherwise.
      bottomNavigationBar:
          (currentPage.showInBottomNav && _bottomPages.length >= 2)
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed, // always show all items
              currentIndex: _currentBottomIndex.clamp(
                0,
                _bottomPages.length - 1,
              ),
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
