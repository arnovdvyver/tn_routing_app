import 'package:flutter/material.dart';
import '../classes/location_model.dart';
import 'package:provider/provider.dart';
import '../providers/user_data_provider.dart';

class AddStopToTrip extends StatefulWidget {
  const AddStopToTrip({super.key});

  @override
  State<AddStopToTrip> createState() => _AddStopToTripState();
}

class _AddStopToTripState extends State<AddStopToTrip> {
  final textController = TextEditingController();
  List<String> selections = [];


  @override
  Widget build(BuildContext context) {
    String currentTripName = Provider.of<User>(context, listen: false).selectedTrip.name;
    List<LocationModel> options = Provider.of<User>(context, listen: false).locations.toList();
    
    return Container (
      padding: const EdgeInsets.all(12.0),
      child:Column(
      children: <Widget>[
        
        //title
        const Align(
          alignment: Alignment.center,
          child: Text("Add Stop(s)",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold
            )
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
            //add items
            for (int i = 0; i < options.length; i++) {
              if (selections.contains(options[i].name)) {
                Provider.of<User>(context, listen: false).addStopToTrip(currentTripName, options[i]);
              }
            }

            //remove page
            Navigator.of(context).pop();
          }, 
          child: const Text("Add")
          )
        ],
      )
    );
  }
}