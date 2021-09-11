import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

import 'meal_item.dart';

class MealList extends StatelessWidget {
  final List<Meal> meals;
  final Function(String) removeMeal;
  final VoidCallback refreshPage;

  MealList(this.meals, this.removeMeal, this.refreshPage);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        final meal = meals[index];
        return MealItem(
          key: ValueKey(meal.id),
          id: meal.id,
          title: meal.title,
          imageUrl: meal.imageUrl,
          duration: meal.duration,
          complexity: meal.complexity,
          affordability: meal.affordability,
          removeItem: removeMeal,
          refreshPage: refreshPage,
        );
      },
      itemCount: meals.length,
    );
  }
}
