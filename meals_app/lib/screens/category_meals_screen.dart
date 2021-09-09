import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/meal_item.dart';

class CategoryMealsScreen extends StatefulWidget {
  static const routeName = "/category-meals";
  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late String categoryTitle;
  late List<Meal> categoryMeals;
  var _loadedInitData = false;

  void removeMeal(String mealId) {
    setState(() {
      var index = categoryMeals.indexWhere((element) => element.id == mealId);
      categoryMeals.removeAt(index);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          final meal = categoryMeals[index];
          return MealItem(
            key: ValueKey(meal.id),
            id: meal.id,
            title: meal.title,
            imageUrl: meal.imageUrl,
            duration: meal.duration,
            complexity: meal.complexity,
            affordability: meal.affordability,
            removeItem: removeMeal,
          );
        },
        itemCount: categoryMeals.length,
      ),
    );
  }
}
