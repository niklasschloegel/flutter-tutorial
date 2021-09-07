import 'package:flutter/material.dart';
import 'package:meals_app/dummy_data.dart';

class MealDetailsScreen extends StatelessWidget {
  static const routeName = "/meal-detail";

  @override
  Widget build(BuildContext context) {
    final _mealId = ModalRoute.of(context)?.settings.arguments as String;
    final _selectedMeal = DUMMY_MEALS.firstWhere((meal) => _mealId == meal.id);
    final _media = MediaQuery.of(context);

    Widget _buildSectionTitle(String text) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.headline6,
        ),
      );
    }

    Widget _buildContainer({required Widget child}) {
      return Container(
          child: child,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.symmetric(
            vertical: 10,
          ),
          padding: EdgeInsets.all(10),
          height: 150,
          width: _media.size.width * 0.9);
    }

    return Scaffold(
      appBar: AppBar(title: Text("${_selectedMeal.title}")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                _selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            _buildSectionTitle("Ingredients"),
            _buildContainer(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  final ingredient = _selectedMeal.ingredients[index];
                  return Card(
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      child: Text(ingredient),
                    ),
                  );
                },
                itemCount: _selectedMeal.ingredients.length,
              ),
            ),
            _buildSectionTitle("Steps"),
            _buildContainer(
              child: ListView.builder(
                itemBuilder: (ctx, index) => Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        child: Text("#${index + 1}"),
                      ),
                      title: Text(_selectedMeal.steps[index]),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                ),
                itemCount: _selectedMeal.steps.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
