import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> initFuture() =>
        Provider.of<GreatPlaces>(context, listen: false).initPlaces();

    Future<void> delete(String id) async {
      try {
        await Provider.of<GreatPlaces>(context, listen: false).deletePlace(id);
      } catch (err) {
        final scaffMessenger = ScaffoldMessenger.of(context);
        scaffMessenger.hideCurrentSnackBar();
        scaffMessenger.showSnackBar(
          SnackBar(
            content: Text("Could not delete"),
          ),
        );
      }
    }

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
        future: initFuture(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: initFuture,
                child: Consumer<GreatPlaces>(
                  builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <=
                          0
                      ? Center(
                          child: Text("Got no places yet, start adding some"))
                      : ListView.builder(
                          itemBuilder: (ctx, i) {
                            final place = greatPlaces.items[i];
                            return Dismissible(
                              key: ValueKey(place.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (_) async => showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title: Text("Delete ${place.title}?"),
                                        content: Text(
                                            "Do you really want to delete this place from your collection?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .errorColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                              onDismissed: (_) async => await delete(place.id),
                              background: Container(
                                color: Theme.of(context).errorColor,
                                child: Padding(
                                  padding: EdgeInsets.all(14),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onError,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              child: ListTile(
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
                              ),
                            );
                          },
                          itemCount: greatPlaces.items.length,
                        ),
                ),
              ),
      ),
    );
  }
}
