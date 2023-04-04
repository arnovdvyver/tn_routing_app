import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routing_app/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import '../providers/location_service_provider.dart';
import '../classes/location_model.dart';
import 'search_bar_widget.dart';

//map widget
class RoutingMap extends StatefulWidget {
  const RoutingMap({super.key});

  @override
  State<RoutingMap> createState() => _RoutingMapState();
}

class _RoutingMapState extends State<RoutingMap> with 
  AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late GoogleMapController _mapController;
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  //move camera to postion of marker
  void _animateToMarker(LatLng markerLocation) {
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(markerLocation, 12));
  }

  //Markerss
  final Set<Marker> _markers = {};

  void _addMarker(LocationModel model, double markerhue, User user) {
    _markers.add(
        Marker(
          markerId: MarkerId(model.placeId),
          position: LatLng(model.geo["lat"], model.geo["lng"]),
          icon: BitmapDescriptor.defaultMarkerWithHue(markerhue),
          infoWindow: InfoWindow(
            title: model.name,
            snippet: model.fullAddress,

            onTap: () => {
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return SimpleDialog(
                    alignment: Alignment.center,
                    contentPadding: const EdgeInsets.all(8.0),
                    title: (user.userSavedLocation.contains(model)) 
                      ? const Text("Location Already Saved")
                      : const Text("Save Ths Location?"),

                    children: [
                      OutlinedButton(
                        onPressed:() {       
                          if (!user.userSavedLocation.contains(model)) {
                            user.saveLocation(model);
                          }
                          Navigator.of(context).pop();
                        },
                        child: (user.userSavedLocation.contains(model)) 
                          ? const Text("Close")
                          : const Text("Save Ths Location?"),
                      )
                    ],

                  );
                }
              )
            },
          ),

        )
    );
  }



  @override
  //UI here

  Widget build(BuildContext context) {
    super.build(context);

    //register User consumer
    return Consumer<User>(
      builder: (context, user, child) {

        // register LocationController consumer
        return Consumer<LocationController>(
          builder: (context, locationController, child) {

            _markers.clear();
            for (LocationModel i in locationController.locations) {
            _addMarker(i, 0, user);
            _animateToMarker(LatLng(i.geo["lat"], i.geo["lng"]));
          }

          if (user.isTripSelected) {
            if (user.inProgress) {
              locationController.setPLP(user.selectedTrip.getPolyLine());

              //add markers
              for (int e = 0; e < user.selectedTrip.tripStops.length; e++) {
                if (e == 0) {
                  _addMarker(user.selectedTrip.tripStops[e], 0, user);
                } else if (e == (user.selectedTrip.tripStops.length - 1)){
                  _addMarker(user.selectedTrip.tripStops[e], 200.00, user);
                } else {
                  _addMarker(user.selectedTrip.tripStops[e], 125.00, user);
                }
              }

              //animate to first see trip
              double lat = user.selectedTrip.tripStops[0].geo["lat"];
              double lng = user.selectedTrip.tripStops[0].geo["lng"];
              _animateToMarker(LatLng(lat, lng));

            } else {
              locationController.removePolylines();
            }
          }


          //start UI widget Tree
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
            children: <Widget> [

                //map view
                GoogleMap(
                  mapToolbarEnabled: false,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-33.964393, 18.425172),
                    zoom: 5,
                  ),
                  onMapCreated: _onMapCreated,
                  polylines: locationController.lines,
                  markers: _markers, 
                  onLongPress:(argument) {
                    if (_markers.length == 1) {
                      _markers.clear();
                    }
                  },
                ),
        
                //search bar
                const Align(
                  alignment: Alignment(0, -0.8),
                  child: AutoSearchBar()
                ),

                //animate to gps button
                Positioned(
                  top: 150,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor:const Color.fromRGBO(241, 95, 41, 0.8),
                    onPressed: () => {
                      _animateToMarker(Provider.of<User>(context, listen: false).userGPS)
                    },
                    child: const Icon(Icons.gps_fixed),
                  ),
                ),

                //save GPS location button
                Positioned(
                  top: 220,
                  right: 20,
                  child: FloatingActionButton(
                    backgroundColor:const Color.fromRGBO(241, 95, 41, 0.8),
                    onPressed: () => {
                        user.saveGPSLocation()
                    },
                    child: const Icon(Icons.pin_drop),
                    ),
                  )
                ]
              )
            );
          }
        );
      }    
    );
  }
}
