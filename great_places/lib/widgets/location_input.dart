import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function(double, double) onSelectPlace;
  const LocationInput({Key? key, required this.onSelectPlace})
      : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  var _isLoading = false;

  void _showPreview(double lat, double lng) {
    final imageUrl = LocationHelper.generateLocationPreviewImageURL(
      latitude: lat,
      longitude: lng,
    );
    setState(() => _previewImageUrl = imageUrl);
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      final locationData = await Location().getLocation();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;
      if (latitude != null && longitude != null) {
        _showPreview(latitude, longitude);
        widget.onSelectPlace(latitude, longitude);
      }
    } catch (err) {
      print(err);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => MapScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) return;
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  Widget _buildLocationPreview() {
    if (_isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );
    if (_previewImageUrl == null)
      return Text(
        "No Location Chosen",
        textAlign: TextAlign.center,
      );
    return Image.network(
      _previewImageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _buildLocationPreview(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text("Current Location"),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text("Select on Map"),
            ),
          ],
        )
      ],
    );
  }
}
