import 'dart:io';

class PlaceLocation {
  final double latitude;
  final double longitude;
  final String address;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
    this.address = "",
  });
}

class Place {
  final String id;
  final String title;
  final PlaceLocation location;
  final File image;

  static const ID_KEY = "id";
  static const TITLE_KEY = "title";
  static const IMAGE_PATH_KEY = "image";
  static const LOC_LAT_KEY = "loc_lat";
  static const LOC_LNG_KEY = "loc_lng";
  static const ADDRESS_KEY = "address";

  const Place({
    required this.id,
    required this.title,
    required this.location,
    required this.image,
  });

  static Place? fromMap(Map<String, Object?> dataMap) {
    final id = dataMap[ID_KEY] as String?;
    final title = dataMap[TITLE_KEY] as String?;
    final imagePath = dataMap[IMAGE_PATH_KEY] as String?;
    final lat = dataMap[LOC_LAT_KEY] as double?;
    final lng = dataMap[LOC_LNG_KEY] as double?;
    final address = dataMap[ADDRESS_KEY] as String?;

    if (id != null &&
        title != null &&
        imagePath != null &&
        lat != null &&
        lng != null &&
        address != null)
      return Place(
        id: id,
        title: title,
        location: PlaceLocation(
          latitude: lat,
          longitude: lng,
          address: address,
        ),
        image: File(imagePath),
      );
  }

  Map<String, Object> toMap() => {
        ID_KEY: id,
        TITLE_KEY: title,
        IMAGE_PATH_KEY: image.path,
        LOC_LAT_KEY: location.latitude,
        LOC_LNG_KEY: location.longitude,
        ADDRESS_KEY: location.address,
      };
}
