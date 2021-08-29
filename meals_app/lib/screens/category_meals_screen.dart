import 'package:flutter/material.dart';
import '../dummy_data.dart';

class CategoryMealsScreen extends StatelessWidget {
  static const routeName = "/category-meals";
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final categoryTitle = routeArgs?['title'] ?? "Title";
    final categoryId = routeArgs?['id'] ?? "ID";
    final categoryMeals = DUMMY_MEALS
        .where((element) => element.categories.contains(categoryId))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          final meal = categoryMeals[index];
          return Text(meal.title);
        },
        itemCount: categoryMeals.length,
      ),
    );
  }
}
