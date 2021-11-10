import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/widgets/image_input.dart';
import 'package:great_places/widgets/location_input.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = "/add-place";

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();
  PlaceLocation? _pickedLocation;
  File? _pickedImage;

  void _selectPlace(double lat, double lng) =>
      _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);

  void _selectImage(File pickedImage) => _pickedImage = pickedImage;

  void _savePlace() {
    final title = _titleController.text;
    final image = _pickedImage;
    final location = _pickedLocation;
    if (title.isEmpty || image == null || location == null) return;
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(title, location, image);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new Place"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: "Title"),
                        controller: _titleController,
                      ),
                      SizedBox(height: 10),
                      ImageInput(onSelectImage: _selectImage),
                      SizedBox(height: 10),
                      LocationInput(onSelectPlace: _selectPlace),
                    ],
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _savePlace,
                icon: Icon(Icons.add),
                label: Text("Add place"),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).accentColor,
                  onPrimary: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
