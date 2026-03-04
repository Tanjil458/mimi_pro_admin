import 'package:flutter/material.dart';
import 'page_config.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.of(context).pop(); // close drawer if open
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = pageItems[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentPage.title),
      ),
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
            for (var i = 0; i < pageItems.length; i++)
              ListTile(
                leading: Icon(pageItems[i].icon),
                title: Text(pageItems[i].title),
                selected: i == _currentIndex,
                onTap: () => _selectPage(i),
              ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pageItems.map((p) => p.widget).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _selectPage,
        items: pageItems
            .map((p) => BottomNavigationBarItem(
                  icon: Icon(p.icon),
                  label: p.title,
                ))
            .toList(),
      ),
    );
  }
}
