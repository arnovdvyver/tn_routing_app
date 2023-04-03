import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';
import 'package:routing_app/classes/location_model.dart';

class LocationCard extends StatefulWidget {
  final LocationModel model;
  const LocationCard({super.key, required this.model});

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color.fromRGBO(255, 249, 249, 1),
        child: Container(
          padding: const EdgeInsets.all(8),
          height: 150,
          width: 380,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text("${widget.model.name}", 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    ),
                ),
              ),

              Align(
                alignment: Alignment.bottomLeft,
                child: Text("${widget.model.fullAddress}"),
              ),

              Align(
                alignment: Alignment.topRight,
                child: OutlinedButton(
                  child: const Text("Remove",
                    style: TextStyle(
                      color: Color.fromRGBO(15, 163, 177, 1)
                    ),
                  ),
                  onPressed: () => {
                    Provider.of<User>(context, listen: false).removeLocation(widget.model)
                  },
                ),
              )
            ],
          ),
        )
      )
    );
  }
}