import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routing_app/widgets/selected_trip_widget.dart';
import 'select_trip_widget.dart';
import 'package:routing_app/widgets/create_trip_widget.dart';
import '../providers/user_data_provider.dart';

class Trips extends StatefulWidget {
  const Trips({super.key});

  @override
  State<Trips> createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Trip Planner",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(241, 94, 41, 1)
                )
              ),

            actions: <Widget>[

              //button to add new trip
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  // Handle search button press
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
                        child: const CreateNewTrip(),
                      );
                    }
                  );     
                }
              ),


              //button to list saved trips
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () {
                  if (user.inProgress) {
                    showDialog(
                      context: context, 
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          contentPadding: const EdgeInsets.all(8.0),
                          title: const Text("Trip is currenly active"),
                          children: [
                            OutlinedButton(
                              onPressed:() {
                                Navigator.of(context).pop();
                                },
                          child: const Text("Close")
                            )
                          ],
                        );
                      }
                    );

                  } else {
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
                        child: const TripsList()
                        );
                     }
                    );
                  }
                }
              ),

              //button to optimise route to shortest distance
              IconButton(
                icon: const Icon(Icons.bolt),
                onPressed: () {
                  if (user.isTripSelected) {
                    user.minTrip();
                  }
                },
              ),


              //active the currently selected route on map
              IconButton(
                icon: const Icon(Icons.route),
                onPressed: () {
                  if (user.isTripSelected) {
                    user.setInProgressState();
                  }
                },
              )
            ]
          ),
            body: const SelectedTrip()
      );
     }
    );
  }
}