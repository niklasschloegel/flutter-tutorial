import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_list.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Meal> favoriteMeals;
  final Function(String) removeMeal;
  FavoritesScreen(this.favoriteMeals, this.removeMeal);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: favoriteMeals.isEmpty
            ? Text("No Favorite meals added yet.")
            : MealList(favoriteMeals, removeMeal),
      ),
    );
  }
}
