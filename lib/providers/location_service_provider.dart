import 'package:flutter/material.dart';
import '../classes/location_model.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//Location Controller
class LocationController with ChangeNotifier {

  //default constructor
  LocationController();

  //Point of Interst
  late LocationModel pointOfInterest;

  //markers
  final Set<LocationModel> locations = {};

  //polylines
  Set<Polyline> lines = {};


  //add searched point's marker to map
  void assignPOI(var data) {
    locations.clear();
    
    pointOfInterest = LocationModel(data["name"], data["place_id"], data["geometry"]["location"], data["formatted_address"]);
    locations.add(pointOfInterest);
    notifyListeners();
  }

  //add Trip's polyline to map
  void setPLP(String encodedPolyline) {
    lines.clear();

    PolylinePoints polylinePoints = PolylinePoints();

    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);
    List<LatLng> mapPoints = [];

    for (var i in result) {
      mapPoints.add(LatLng(i.latitude, i.longitude));
    }

    Polyline polyline = Polyline(
      polylineId: const PolylineId('Route'),
      color: Colors.blue,
      width: 5,
      points: mapPoints,
      visible: true
    );

    lines.add(polyline);
    notifyListeners();
  }

  void removePolylines() {
    lines.clear();
    notifyListeners();
  }
}
