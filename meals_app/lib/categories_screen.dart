import 'package:flutter/material.dart';
import 'package:meals_app/category_item.dart';
import 'dummy_data.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DeliMeal'),
      ),
      body: SafeArea(
        child: GridView(
          padding: EdgeInsets.all(25),
          children: DUMMY_CATEGORIES
              .map((categoryData) => CategoryItem(
                    id: categoryData.id,
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
      ),
    );
  }
}
