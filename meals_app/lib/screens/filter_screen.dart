import 'package:flutter/material.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class FilterScreen extends StatefulWidget {
  static const routeName = "/filters";
  final Map<String, bool> filters;
  final Function saveFilters;

  FilterScreen(this.filters, this.saveFilters);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late var _glutenFree = widget.filters['gluten'] ?? false;
  late var _lactoseFree = widget.filters['lactose'] ?? false;
  late var _vegetarian = widget.filters['vegetarian'] ?? false;
  late var _vegan = widget.filters['vegan'] ?? false;

  @override
  Widget build(BuildContext context) {
    Widget _buildSwitchListTile(
      String title,
      String description,
      bool currentValue,
      Function(bool) updateValue,
    ) {
      return SwitchListTile(
        onChanged: updateValue,
        value: currentValue,
        title: Text(title),
        subtitle: Text(description),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
      ),
      drawer: MainDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.saveFilters({
            'gluten': _glutenFree,
            'lactose': _lactoseFree,
            'vegetarian': _vegetarian,
            'vegan': _vegan,
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Saved successfully")));
        },
        child: Icon(Icons.save),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              "Adjust your meal selection",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSwitchListTile(
                  "Gluten-free",
                  "Only include gluten-free meals.",
                  _glutenFree,
                  ((newValue) {
                    setState(() => _glutenFree = newValue);
                  }),
                ),
                _buildSwitchListTile(
                  "Vegetarian",
                  "Only include vegetarian meals.",
                  _vegetarian,
                  ((newValue) {
                    setState(() => _vegetarian = newValue);
                  }),
                ),
                _buildSwitchListTile(
                  "Vegan",
                  "Only include vegan meals.",
                  _vegan,
                  ((newValue) {
                    setState(() => _vegan = newValue);
                  }),
                ),
                _buildSwitchListTile(
                  "Lactose-free",
                  "Only include lactose-free meals.",
                  _lactoseFree,
                  ((newValue) {
                    setState(() => _lactoseFree = newValue);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
