import 'package:flutter/material.dart';
import 'package:meals_app/screens/filter_screen.dart';

class MainDrawer extends StatelessWidget {
  void _handleMealsClicked(BuildContext context) =>
      Navigator.of(context).pushReplacementNamed("/");

  void _handleFilterClicked(BuildContext context) =>
      Navigator.of(context).pushReplacementNamed(FilterScreen.routeName);

  Widget _buildListTile(
    String title,
    IconData icon,
    VoidCallback onTapHandler,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "RobotoCondensed",
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).accentColor,
            child: Container(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Cooking Up!",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildListTile(
              "Meals", Icons.restaurant, () => _handleMealsClicked(context)),
          _buildListTile(
              "Filter", Icons.filter_alt, () => _handleFilterClicked(context)),
        ],
      ),
    );
  }
}
