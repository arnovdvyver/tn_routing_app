import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

//places API Request - retrieve autocomplete suggestions
String? key = dotenv.env["MAPS_API_KEY"];

Future autoSearch(String? userTyping) async {
  List<String> autoPredictions = [];

  final url = Uri.parse('https://maps.googleapis.com/maps/api/place/queryautocomplete/json'
  '?input=$userTyping'
  '&location=-34.069011, 18.8374046&radius=5000'
  '&key=$key'
  );
  final response = await http.get(url);
  var jsonResp = json.decode(response.body);

  autoPredictions.clear();
  for (var options in jsonResp["predictions"]) {

    String name = options["description"];
    //String value = options["place_id"]; //testing

    autoPredictions.add(name);
  }

  return autoPredictions;
}

//places API Request - retrieve detailed information about location via placeID
Future placeDetails(String name) async {

  final url = Uri.parse('https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
    '?input=$name'
    '&inputtype=textquery'
    '&fields=formatted_address,geometry/location,name,place_id'
    '&key=$key'
  );

  final response = await http.get(url);
  return json.decode(response.body)['candidates'][0];
}

//searcg via coordinates instead of text
Future reverseGeocode(LatLng geo) async {
  final url = Uri.parse('https://maps.googleapis.com/maps/api/geocode/json'
    '?latlng=${geo.latitude},${geo.longitude}'
    '&key=$key'
  );

  final response = await http.get(url);
  return json.decode(response.body)['results'][0];
}