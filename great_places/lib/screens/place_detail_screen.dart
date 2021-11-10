import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = "/place-detail";
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedPlace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedPlace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
              "${selectedPlace.location.latitude.toStringAsFixed(4)}, ${selectedPlace.location.longitude.toStringAsFixed(4)}"),
          if (selectedPlace.location.address != "")
            Column(
              children: [
                Text(
                  selectedPlace.location.address,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (ctx) => MapScreen(
                  initialLocation: selectedPlace.location,
                ),
              ),
            ),
            child: Text("View on Map"),
          ),
        ],
      ),
    );
  }
}
