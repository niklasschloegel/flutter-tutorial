import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:great_places/helpers/db_helper.dart';
import 'package:great_places/helpers/fs_helper.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';
import 'package:uuid/uuid.dart';

class GreatPlaces with ChangeNotifier {
  static const _TABLE = "user_places";
  List<Place> _items = [];

  List<Place> get items => [..._items];

  Place findById(String id) => _items.firstWhere((element) => element.id == id);

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
    final savedImage = await FsHelper.saveFile(image);

    final newPlace = Place(
      id: Uuid().v4(),
      title: title,
      location: updatedLocation,
      image: savedImage,
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
    print("initting");
    notifyListeners();
  }

  Future<void> deletePlace(String id) async {
    final prevPlaceIndex = _items.indexWhere((element) => element.id == id);
    final prevPlace = _items[prevPlaceIndex];
    _items.removeAt(prevPlaceIndex);
    notifyListeners();
    try {
      await DBHelper.delete(_TABLE, Place.ID_KEY, id);
      await FsHelper.removeFile(prevPlace.image);
    } catch (err) {
      print(err);
      _items.insert(prevPlaceIndex, prevPlace);
      notifyListeners();
      throw err;
    }
  }
}
