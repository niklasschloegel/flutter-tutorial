import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_places/helpers/location_helper.dart';
import 'package:great_places/models/place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;
  const MapScreen({
    Key? key,
    this.initialLocation = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
    ),
    this.isSelecting = false,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  var _isLoading = false;
  late GoogleMapController _mapController;

  LatLng get _initialLocationAsLatLng => LatLng(
        widget.initialLocation.latitude,
        widget.initialLocation.longitude,
      );

  Set<Marker> initMarkers() {
    var pickedLoc = _pickedLocation;
    if (pickedLoc == null && !widget.isSelecting)
      return {
        Marker(
          markerId: MarkerId("m1"),
          position: _initialLocationAsLatLng,
        )
      };
    if (pickedLoc != null)
      return {
        Marker(
          markerId: MarkerId("m1"),
          position: pickedLoc,
        )
      };
    return {};
  }

  void _selectLocation(LatLng position) {
    setState(() => _pickedLocation = position);
  }

  Future<void> searchLocation(String value) async {
    setState(() => _isLoading = true);
    try {
      final location = await LocationHelper.searchPlace(value);
      if (location != null) {
        setState(() => _pickedLocation = location);
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
      }
    } catch (err) {
      print(err);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () => _pickedLocation == null
                  ? null
                  : Navigator.of(context).pop(_pickedLocation),
              icon: Icon(Icons.check),
            )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (ctr) => _mapController = ctr,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: _initialLocationAsLatLng,
              zoom: 16,
            ),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: initMarkers(),
          ),
          if (widget.isSelecting)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              width: double.infinity,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search for a place...",
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                  suffixIcon: Icon(Icons.search),
                ),
                keyboardType: TextInputType.streetAddress,
                textInputAction: TextInputAction.search,
                onSubmitted: (val) async => await searchLocation(val),
              ),
            ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
