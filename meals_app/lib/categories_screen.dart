import 'package:flutter/material.dart';
import 'package:meals_app/category_item.dart';
import 'dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        children: DUMMY_CATEGORIES
            .map((categoryData) => CategoryItem(
                  title: categoryData.title,
                  color: categoryData.color,
                ))
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
      ),
    );
  }
}
