import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/favorites_screen.dart';
import 'package:meals_app/widgets/main_drawer.dart';

import 'categories_screen.dart';

class TabsScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;
  final Function(String) removeMeal;
  TabsScreen(this.favoriteMeals, this.removeMeal);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _PageItem {
  final Widget page;
  final String title;

  _PageItem(this.page, this.title);
}

class _TabsScreenState extends State<TabsScreen> {
  late final _pages = [
    _PageItem(CategoriesScreen(), "Categories"),
    _PageItem(
        FavoritesScreen(widget.favoriteMeals, widget.removeMeal), "Favorites"),
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
      drawer: MainDrawer(),
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
