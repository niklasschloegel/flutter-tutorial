import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';
import 'package:uuid/uuid.dart';

class GreatPlaces with ChangeNotifier {
  static const _TABLE = "user_places";
  List<Place> _items = [];

  List<Place> get items => [..._items];

  Future<void> addPlace(
    String title,
    PlaceLocation location,
    File image,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
        location.latitude, location.longitude);
    final updatedLocation = PlaceLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      address: address,
    );

    final newPlace = Place(
      id: Uuid().v4(),
      title: title,
      location: updatedLocation,
      image: image,
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(_TABLE, newPlace.toMap());
  }

  Future<void> initPlaces() async {
    final dataList = await DBHelper.getData(_TABLE);
    _items = dataList
        .map((dataMap) => Place.fromMap(dataMap))
        .whereType<Place>()
        .toList();
  }
}
