import 'package:routing_app/utils/google_directions.dart';
import 'location_model.dart';
import '../classes/directions_model.dart';

class Trip {
  final _name;
  late List<LocationModel> _tripStops;
  late int _stopCount;
  late Directions _directionsController;
  double _userDistanceTravelled = 0;

  //master notifier
  Function notifierCallback;

  //default constructo
  Trip(this._name, this.notifierCallback) {
    _tripStops = [];
    _stopCount = 0;
    _directionsController = Directions(notifierCallback);
  }

  //add tripStop
  void addStop(LocationModel newStop) {
    _tripStops.add(newStop);
    _stopCount = _tripStops.length;
    updatePartitions();

    if (_stopCount > 1) {
      _directionsController.updateProperties(_tripStops, updatePartitions);
      updatePartitions();
    }
    notifierCallback();
  }

  //remove tripStop
  void removeStop(LocationModel stopToRemove) {
    _tripStops.remove(stopToRemove);
    _stopCount = _tripStops.length;

    if (_stopCount > 1) {
      _directionsController.updateProperties(_tripStops, updatePartitions);
      updatePartitions();
    } else {
      _directionsController.noRoute();
    }

    notifierCallback();
  }

  //reorder elemetns in list
  void reOrderStops(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
          newIndex -= 1;
    }

    LocationModel item = tripStops.removeAt(oldIndex);
    tripStops.insert(newIndex, item);

    //update direction with new order
    _directionsController.updateProperties(_tripStops, updatePartitions);

    notifierCallback();
  }

  //optimise element order
  void optimiseTrip() async {
    if (_stopCount > 3) {
      List sequence = await getOptimalWaypoints(_tripStops);

      //create new
      List<LocationModel> newList = [];

      //add origin
      newList.add(_tripStops.first);

      //add waypoints
      for (var index in sequence) {
        //int i = int.parse(index);
        newList.add(_tripStops[index + 1]);
      }

      //add destination
      newList.add(_tripStops.last);

      //replace and 
      replaceTrips(newList);
    }
    notifierCallback();
  }

  void replaceTrips(List<LocationModel> optimisedTrip) {
    _tripStops.clear();
    _tripStops = optimisedTrip;
    _stopCount = _tripStops.length;
    _directionsController.updateProperties(_tripStops, updatePartitions);

    notifierCallback();
  }

  //update leg distance associated with each stop
  void updatePartitions() {
    int count = _directionsController.tripLegs.length;
    print(count);

    //set partitions
    for (int i = 0; i < count; i++) {
      double value = _directionsController.tripLegs[i];
      _tripStops[i + 1].setDistancePartition(value);
    }
  }

  void incrementUserDistance(double value) {
    _userDistanceTravelled += value;
    notifierCallback();
  }

  String getPolyLine() {
    return _directionsController.polyline;
  }

  String getDistance() {
    return "${(_directionsController.distance / 1000).round()} KM";
  }

  String getTime() {
    return "${(_directionsController.time  / 60).round()} mins";
  }

  //get trip name
  String get name => _name;
  int get tripStopCount => _stopCount;
  List<LocationModel> get tripStops => _tripStops;
  String get accumulatedDistance => "${(_userDistanceTravelled / 1000).round()} KM";
}
