import 'package:flutter/material.dart';
import 'package:routing_app/utils/google_places.dart';
import '../classes/trip_model.dart';
import 'package:provider/provider.dart';
import 'package:routing_app/providers/user_data_provider.dart';

class TripRoute extends StatefulWidget {
  const TripRoute({super.key});

  @override
  State<TripRoute> createState() => _TripRouteState();
}

class _TripRouteState extends State<TripRoute> {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
      builder: (context, user, child) {
        Trip tripInView = user.selectedTrip;

        if (user.selectedTrip.tripStopCount == 0) {
          return const Text("Not updated");
        }

        return Column(children: [ 
          Text(tripInView.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),

          Expanded(
            child: ReorderableListView(
              onReorder:(oldIndex, newIndex) {
                if (!user.inProgress) {
                  setState(() {
                    tripInView.reOrderStops(oldIndex, newIndex);
                  });
                }
              },
              children: tripInView.tripStops.map((e) {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  height: 120,
                  decoration: const BoxDecoration(
                    border: Border(
                    bottom: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),),
                  key: UniqueKey(),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(e.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.centerRight,
                              child: Visibility(
                                visible: (user.inProgress) ? true : false,
                                child: IconButton(
                                onPressed:() {
                                    user.selectedTrip.incrementUserDistance(e.partition);
                                },
                                icon: const Icon(Icons.check)
                            ),
                          )
                              )
                            ]
                          ),
                        ),
                         Align(
                          alignment: Alignment.centerRight,
                          child: Visibility(
                            visible: (!user.inProgress && (user.selectedTrip.tripStopCount > 2)) 
                              ? true 
                              : false,

                            child: IconButton(
                              onPressed:() {
                                user.selectedTrip.removeStop(e);
                              },
                              icon: const Icon(Icons.close)
                            ),
                          )
                        ),

                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Text("${(e.partition / 1000).round()} KM Traveled"),
                        )
                      ],
                    )
                  );
                }).toList()
              )
            )
          ]
        );
      }
    );
  }
}