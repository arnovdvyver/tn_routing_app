import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_service_provider.dart';
import '../utils/google_places.dart' as gp;

class AutoSearchBar extends StatefulWidget {
  const AutoSearchBar({super.key});

  @override
  State<AutoSearchBar> createState() => _AutoSearchBarState();
}

class _AutoSearchBarState extends State<AutoSearchBar> {
  final _searchController = TextEditingController();

  void _handleTextSubmit(String value) {
    _searchController.clear();
  }

  void _clearTextField() {
    _searchController.clear();
    FocusScope.of(context).requestFocus(new FocusNode());
}

  //On-mount
  @override
  void initState() {
    super.initState();
  }

  //on dismount
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        alignment: Alignment.center,
        width: 360,
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          backgroundBlendMode: BlendMode.clear
        ),
          child: Autocomplete<String>(

            //styling of Search-bar textfield
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
              return TextField(
                onSubmitted: _handleTextSubmit,
                controller: controller,
                focusNode: focusNode,
                onEditingComplete: onEditingComplete,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search Location',
                  filled: true,
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromRGBO(241, 95, 41, 0.4), width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color.fromRGBO(241, 95, 41, 0.8), width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                )
              );
            },

            //auto-complete options builder
            optionsBuilder: (TextEditingValue textFieldValue) async {
              if (textFieldValue.text == '') {
                return const Iterable<String>.empty();

              } else {

                List<String> options = await gp.autoSearch(textFieldValue.text);
                return options;
            }
        },
        onSelected: (String selection) {
          _searchController.text = selection;

          //pass selection to location_services provider
          gp.placeDetails(selection).then(
            (value) => Provider.of<LocationController>(context, listen: false).assignPOI(value)
          );

          _clearTextField();
         },
        ) 
      )
    );
  }
}