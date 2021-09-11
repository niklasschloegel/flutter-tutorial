import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_list.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = "/category-meals";
  final List<Meal> availableMeals;
  final Function(String) removeMeal;

  CategoryMealsScreen(this.availableMeals, this.removeMeal);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late String categoryTitle;
  late List<Meal> categoryMeals;
  var _loadedInitData = false;

  @override
  void didChangeDependencies() {
    if (!_loadedInitData) {
      final routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
      final categoryId = routeArgs?['id'] ?? "ID";

      categoryTitle = routeArgs?['title'] ?? "Title";
      categoryMeals = widget.availableMeals
          .where((element) => element.categories.contains(categoryId))
          .toList();
    }
    _loadedInitData = true;
    super.didChangeDependencies();
  }

  void refresh() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: MealList(categoryMeals, widget.removeMeal),
    );
  }
}
