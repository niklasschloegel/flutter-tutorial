import 'package:flutter/material.dart';
import 'package:meals_app/screens/favorites_screen.dart';

import 'categories_screen.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _PageItem {
  final StatelessWidget page;
  final String title;

  _PageItem(this.page, this.title);
}

class _TabsScreenState extends State<TabsScreen> {
  final _pages = [
    _PageItem(CategoriesScreen(), "Categories"),
    _PageItem(FavoritesScreen(), "Favorites"),
  ];

  var _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  _PageItem get _selectedPage {
    return _pages[_selectedPageIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPage.title),
      ),
      drawer: Drawer(child: Text("Drawer")),
      body: _selectedPage.page,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            label: "Favorites",
          )
        ],
      ),
    );
  }
}
