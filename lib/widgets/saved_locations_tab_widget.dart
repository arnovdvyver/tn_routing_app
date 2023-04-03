
import 'package:flutter/material.dart';
import 'package:routing_app/providers/user_data_provider.dart';
import 'saved_location_card_widget.dart';
import 'package:provider/provider.dart';
import 'package:routing_app/classes/location_model.dart';

class SavedLocations extends StatefulWidget {
  const SavedLocations({super.key});

  @override
  State<SavedLocations> createState() => _SavedLocationsState();
}

class _SavedLocationsState extends State<SavedLocations> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Locations", 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(241, 94, 41, 1)
            )
          ),
      ),
      body: Consumer<User> (
        builder: (context, user, child) {
          List<LocationModel> listCards = user.locations.toList();

          if (listCards.isEmpty) {
            return const Center(child: Text("No Saved Locations", style: TextStyle(fontWeight: FontWeight.bold)));
          } else {
            return ListView.builder(
              itemCount: listCards.length,
              itemBuilder: (context, index) {
                return LocationCard(model: listCards[index]);
              }
            );
          }
        }
      )
    );
  }
}