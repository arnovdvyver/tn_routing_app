import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';


class TripsList extends StatefulWidget {
  const TripsList({super.key});

  @override
  State<TripsList> createState() => _TripsListState();
}

class _TripsListState extends State<TripsList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<User>(
        builder: (context, user, child) {
          return Container(

            //list builder
            child: ListView.builder(
            itemCount: user.trips.length,
            itemBuilder: (BuildContext context, index) {

              //display list of saved trips
              return ListTile(
                title: Text(user.trips[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {

                    //throw dialog box if user tries to delete during a trip
                    if (user.inProgress || (user.trips.length == 1)) {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            alignment: Alignment.center,
                            contentPadding: const EdgeInsets.all(8.0),
                            title: (user.inProgress) 
                              ? const Text("Current Route is still active.")
                              : const Text("Cannot Delete only route"),
                            children: [
                              OutlinedButton(
                                onPressed:() {
                                  Navigator.of(context).pop();
                                 },
                            child: const Text("Close")
                              )
                            ]   ,
                         );
                        }
                      );
                    // } else if ((user.trips[index]).name == user.selectedTrip.name) {
                    //   showDialog(
                    //     context: context, 
                    //     builder: (BuildContext context) {
                    //       return SimpleDialog(
                    //         alignment: Alignment.center,
                    //         contentPadding: const EdgeInsets.all(8.0),
                    //         title: const Text("Cannot delete currenly selected route"),
                    //         children: [
                    //           OutlinedButton(
                    //             onPressed:() {
                    //               Navigator.of(context).pop();
                    //              },
                    //         child: const Text("Close")
                    //           )
                    //         ]   ,
                    //      );
                    //     }
                    //   );
                    // } else {
                      //adjust list if free to do so
                      setState(() {
                        user.removeTrip(user.trips[index]);
                      });
                    }
                  },
                ),
                onTap: () {
                  user.setActiveTrip(user.trips[index]);
                  Navigator.of(context).pop();
                  },
                );
              }
            )
          );
        }
      );
  }
}