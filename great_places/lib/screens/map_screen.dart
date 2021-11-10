import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocationAsLatLng,
          zoom: 16,
        ),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: initMarkers(),
      ),
    );
  }
}
