import 'package:flutter/material.dart';
import 'package:meals_app/dummy_data.dart';
import 'package:meals_app/screens/category_meals_screen.dart';
import 'package:meals_app/screens/filter_screen.dart';
import 'package:meals_app/screens/meal_detail_screen.dart';
import 'package:meals_app/screens/tabs_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _filter = {
    'gluten': false,
    'lactose': false,
    'vegetarian': false,
    'vegan': false,
  };
  Map<String, bool> get filter => _filter;
  var _availableMeals = DUMMY_MEALS;

  void _setFilters(Map<String, bool> filterData) => setState(() {
        _filter = filterData;
        _availableMeals = DUMMY_MEALS.where((meal) {
          if ((_filter["gluten"] ?? false) && !meal.isGlutenFree) return false;
          if ((_filter["lactose"] ?? false) && !meal.isLactoseFree)
            return false;
          if ((_filter["vegetarian"] ?? false) && !meal.isVegetarian)
            return false;
          if ((_filter["vegan"] ?? false) && !meal.isVegan) return false;
          return true;
        }).toList();
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.amber,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText2: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              bodyText1: TextStyle(color: Color.fromRGBO(20, 51, 51, 1)),
              headline6: TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      home: TabsScreen(),
      routes: {
        CategoryMealsScreen.routeName: (_) =>
            CategoryMealsScreen(_availableMeals),
        MealDetailsScreen.routeName: (_) => MealDetailsScreen(),
        FilterScreen.routeName: (_) => FilterScreen(filter, _setFilters),
      },
    );
  }
}
