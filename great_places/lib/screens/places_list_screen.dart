import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Places"),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false).initPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<GreatPlaces>(
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? Center(
                        child: Text("Got no places yet, start adding some"))
                    : ListView.builder(
                        itemBuilder: (ctx, i) {
                          final place = greatPlaces.items[i];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(place.image),
                            ),
                            title: Text(place.title),
                            subtitle: place.location.address == ""
                                ? null
                                : Text(place.location.address),
                            onTap: () => Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: place.id,
                            ),
                          );
                        },
                        itemCount: greatPlaces.items.length,
                      ),
              ),
      ),
    );
  }
}
