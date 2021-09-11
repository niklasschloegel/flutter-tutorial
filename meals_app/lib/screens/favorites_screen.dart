import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_list.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Meal> favoriteMeals;
  final Function(String) removeMeal;
  FavoritesScreen(this.favoriteMeals, this.removeMeal);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: widget.favoriteMeals.isEmpty
            ? Text("No Favorite meals added yet.")
            : MealList(widget.favoriteMeals, widget.removeMeal, refreshPage),
      ),
    );
  }
}
