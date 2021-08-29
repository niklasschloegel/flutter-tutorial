import 'package:flutter/material.dart';

class CategoryMealsScreen extends StatelessWidget {
  static const routeName = "/category-meals";
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final categoryTitle = routeArgs?['title'] ?? "Title";
    final categoryId = routeArgs?['id'] ?? "ID";

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: Center(
        child: Text(categoryTitle),
      ),
    );
  }
}
