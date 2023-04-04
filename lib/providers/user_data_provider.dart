import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../classes/location_model.dart';
import '../classes/trip_model.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/google_places.dart';

class User with ChangeNotifier {
  Location location = Location();
  late String _name;
  late FirebaseFirestore db;
  late LatLng userGPSLocation;

  Set<LocationModel> userSavedLocation = {};
  Map<String, Trip> userSavedTrips = {};


  late Trip _activeTrip; //the trip in focus on "Route Planner" tab
  bool _tripSelected = false; //flag to help control display
  bool _isInProgress = false; //flag to control Route activation on Map


  User(this._name, this.db) {
    //init gps location
    setGPSCoordinates().then((value) => {
      userGPSLocation = value
    });

    //load data from Firestore here
    DocumentReference d = db.collection("user_data").doc("locations");
    loadUserdata(d);
  }

  //load all user data from Firestore
  void loadUserdata(DocumentReference docRef) async {
    List locationDataToLoad = [];

    DocumentSnapshot doc = await docRef.get();
    if (doc.exists){
      final data = doc.data()! as Map<String, dynamic>;
      locationDataToLoad = data["saved_locations"]!;

      for (Map element in locationDataToLoad) {
        double lat = element["geo"].latitude;
        double lng = element["geo"].longitude;
        Map geoPoints = {
          "lat": lat,
          "lng": lng 
        };

        LocationModel model = LocationModel(
          element["name"], 
          element["place_id"], 
          geoPoints,
          element["address"]
        );
        saveLocation(model);
      }
    } else {
      debugPrint("This document does not exist.");
    }
  }

  //Sets user GPS coordinates
  Future<LatLng> setGPSCoordinates() async  {
    LocationData locationData = await location.getLocation();
    LatLng latLng = LatLng(locationData.latitude!, locationData.longitude!);

    return latLng;
  }

  //save new location
  void saveLocation(LocationModel newLocation) {
    //update date in local memory
    userSavedLocation.add(newLocation);
    notifyListeners();

    //do not save GPS Pins to persistent location
    if (newLocation.name != "UserPin") {

    //update location in Firestore
      final data = {
        "name": newLocation.name,
        "place_id": newLocation.placeId,
        "geo": GeoPoint(newLocation.geo["lat"], newLocation.geo["lng"]),
        "address": newLocation.address
      };

      db.collection("user_data").doc("locations").update({
        'saved_locations': FieldValue.arrayUnion([data]),
      }).then((value) {
        debugPrint("Data added to document");
      }).catchError((error) {
        debugPrint("Failed to Update: $error");
      });
    }
  }
  
    //remove saved location
    void removeLocation(LocationModel locationToRemove) {
      userSavedLocation.remove(locationToRemove);
      notifyListeners();

      final data = {
        "name": locationToRemove.name,
        "place_id": locationToRemove.placeId,
        "geo": GeoPoint(locationToRemove.geo["lat"], locationToRemove.geo["lng"]),
        "address": locationToRemove.address
      };

      db.collection("user_data").doc("locations").update({
        'saved_locations': FieldValue.arrayRemove([data]),
      }).then((value) {
        debugPrint("Data removed from document");
      }).catchError((error) {
        debugPrint("Failed to Update: $error");
      });
    }

  //trip functions
  //add new trip to list
  void addTrip(String id) {
    userSavedTrips[id] = Trip(id, () => notifyListeners());
    notifyListeners();
  }

  //remove
  void removeTrip(String id) {
    userSavedTrips.remove(id);
    notifyListeners();
  }

  //add new stop
  void addStopToTrip(String id, LocationModel newStop) {
    userSavedTrips[id]?.addStop(newStop);
    notifyListeners();
  }

  //remove stop from trip
  void removeStopFromTrip(String id, LocationModel oldStop) {
    userSavedTrips[id]?.removeStop(oldStop);
    notifyListeners();
  }

  //set active trip
  void setActiveTrip(String name) {
    _activeTrip = userSavedTrips[name]!;
    _tripSelected = true;
    notifyListeners();
  }

  //set trip the current active trip inProgress
  void setInProgressState() {
    _activeTrip.resetTravelledDistance();
    _activeTrip.resetAllVisitedFlags();
    _isInProgress = (!_isInProgress) ? true : false;
    notifyListeners();
  }

  //optimise selected trip
  void minTrip() {
   _activeTrip.optimiseTrip();
  }


  void saveGPSLocation() async {
    final resp = await reverseGeocode(userGPS);

    Map geoPoint= {"lat": userGPS.latitude, "lng": userGPS.longitude};
    String adrs = resp["formatted_address"];
    String id = resp["place_id"];
    
    LocationModel userLocation = LocationModel("UserPin", id, geoPoint, adrs);
    saveLocation(userLocation);
  }

  Trip get selectedTrip => _activeTrip;
  bool get isTripSelected => _tripSelected;
  bool get inProgress => _isInProgress;

  Set<LocationModel> get locations => userSavedLocation;
  List<String> get trips => userSavedTrips.keys.toList();
  LatLng get userGPS => userGPSLocation;
}