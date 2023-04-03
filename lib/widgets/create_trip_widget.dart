import 'package:flutter/material.dart';
import '../classes/location_model.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';

class CreateNewTrip extends StatefulWidget {
  const CreateNewTrip({super.key});

  @override
  State<CreateNewTrip> createState() => _CreateNewTripState();
}

class _CreateNewTripState extends State<CreateNewTrip> {
  final textController = TextEditingController();
  List<String> selections = [];


  @override
  Widget build(BuildContext context) {
    List<LocationModel> options = Provider.of<User>(context, listen: false).locations.toList();
    
    return Container (
      padding: const EdgeInsets.all(12.0),
      child:Column(
      children: <Widget>[
        
        //title
        const Align(
          alignment: Alignment.center,
          child: Text("New Trip",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            )
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        //textfield
        SizedBox(
          width: 300,
          child: TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: "Trip Name",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(241, 95, 41, 0.4), width: 2.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color.fromRGBO(241, 95, 41, 0.8), width: 2.0),
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 35,
        ),

        //List
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: options.map((e) => 
            ChoiceChip(
              label: Text(e.name),
              selected: selections.contains(e.name),
              onSelected: (value) {
                setState(() {
                  if (value) {
                    selections.add(e.name);
                  } else {
                    selections.remove(e.name);
                  }
                }
              );
              },
              )
            ).toList()
          ),

          const SizedBox(
          height: 35,
        ),

        TextButton(
          onPressed:() {
            if (selections.isEmpty) {
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return SimpleDialog(
                    alignment: Alignment.center,
                    contentPadding: const EdgeInsets.all(8.0),
                    title: const Text("Cannot create and empty Route!"),
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

            } else if (selections.length < 2) {
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return SimpleDialog(
                    alignment: Alignment.center,
                    contentPadding: const EdgeInsets.all(8.0),
                    title: const Text("Trip requires atleast 2 TripStops, please add another TripStop"),
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
              //add new Trip to user
              String tripName = textController.text;
              Provider.of<User>(context, listen: false).addTrip(tripName);

              //add items
              for (int i = 0; i < options.length; i++) {
                if (selections.contains(options[i].name)) {
                  Provider.of<User>(context, listen: false).addStopToTrip(tripName, options[i]);
                }
              }
              //remove page
              Navigator.of(context).pop();
              }
            }, 
          child: const Text("Create Now")
          )
        ],
      )
    );
  }
}