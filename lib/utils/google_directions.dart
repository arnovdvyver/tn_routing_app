import 'dart:async';
import 'dart:convert';
import '../classes/location_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


//places API Request - retrieve autocomplete suggestions
String? key = dotenv.env["MAPS_API_KEY"];

Future mapDirection(List<LocationModel> tripStops) async {
  List<LocationModel> points = tripStops;
  String wayPointsBuilder = "";
  final url;
  
  if (points.length > 2) {
    for (int i = 1; i < (points.length - 1); i++) {
      String partition = "place_id:${points[i].placeId}|";
      wayPointsBuilder += partition;
    }

    url = Uri.parse('https://maps.googleapis.com/maps/api/directions/json'
    '?origin=place_id:${points.first.placeId}' //set origin to first element
    '&destination=place_id:${points.last.placeId}' //set destination to last element
    '&waypoints=$wayPointsBuilder'
    '&key=$key'
    );
  } else {
    url = Uri.parse('https://maps.googleapis.com/maps/api/directions/json'
    '?origin=place_id:${points.first.placeId}' //set origin to first element
    '&destination=place_id:${points.last.placeId}' //set destination to last element
    '&key=$key'
    );
  }

  final response = await http.get(url);
  return json.decode(response.body)["routes"][0];
}


Future getOptimalWaypoints(List<LocationModel> activeTripStops) async {
  List<LocationModel> points = activeTripStops;
  String wayPointsBuilder = "";


  for (int i = 1; i < (points.length - 1); i++) {
    String partition = "|place_id:${points[i].placeId}";
    wayPointsBuilder += partition;
  }

  final url = Uri.parse('https://maps.googleapis.com/maps/api/directions/json'
    '?origin=place_id:${points.first.placeId}' //set origin to first element
    '&destination=place_id:${points.last.placeId}' //set destination to last element
    '&waypoints=optimize:true$wayPointsBuilder'
    '&key=$key'
  );

  final response = await http.get(url);
  return json.decode(response.body)["routes"][0]["waypoint_order"];
}