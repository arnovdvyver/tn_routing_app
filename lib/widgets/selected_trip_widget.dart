import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing_app/providers/user_data_provider.dart';
import 'package:routing_app/widgets/add_stop_widget.dart';
import 'package:routing_app/widgets/trip_route_widget.dart';

class SelectedTrip extends StatefulWidget {
  const SelectedTrip({super.key});

  @override
  State<SelectedTrip> createState() => _SelectedTripState();
}

class _SelectedTripState extends State<SelectedTrip> {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        if (!user.isTripSelected) {
          return const Align(
            alignment: Alignment.center,
            child: Text("No Trip Selected"),
          );
        } else {
        return Scaffold(
          body: Stack(
            alignment: Alignment.center,
            children: [
              const TripRoute(),

              //floating action button
              Positioned(
                bottom: 50,
                right: 30,
                child: FloatingActionButton(
                  child: const Icon(Icons.add_location),
                  onPressed:() {
                    showModalBottomSheet(
              context: context, 
              shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                ),
              ),

              builder: (BuildContext context) {
                return Container(
                  height: 400,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 249, 252, 255),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: const AddStopToTrip()
                        );
                      }
                    );
                  },
                )
              ),

              Positioned(
                bottom: 40, // position from the top of the stack
                left: 20, // position from the left of the stack
                child: Column(
                  children: [
                    Text("Trip Distance: ${user.selectedTrip.getDistance()}"), 
                    Text("Trip Duration: ${user.selectedTrip.getTime()}"),
                    (user.inProgress) 
                      ? const Text("Trip Started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(241, 95, 41, 1)
                        )) 

                      : const Text("Trip Not Started",
                        style: TextStyle(
                          fontSize: 16,
                          ),
                        ),
                    
                    (user.inProgress) ? Text("User Travelled Distance: ${user.selectedTrip.accumulatedDistance}") 
                      : const Text(" ")
                  ]
                ) 
              ),
             ],
           ),
          );
        }
      },
    );
  }
}