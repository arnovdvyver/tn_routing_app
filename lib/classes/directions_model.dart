import '../utils/google_directions.dart';
import '../classes/location_model.dart';

class Directions {
  late String _polylineEncoded;
  List<double> tripLegs = [];
  double _totalDistance = 0;
  double _totalTime = 0;
  Function notifierCallback;

  
  //constructor
  Directions(this.notifierCallback);


  //update properties from Google Directions API
  updateProperties(List<LocationModel> tripStops, Function updateCallback) async {
    double tempDistance = 0;
    double tempTime = 0;

    //request new Distance API data
    var response = await mapDirection(tripStops);

    //set new polyline data
    _polylineEncoded = response["overview_polyline"]["points"];


    //get new distance and time data
    tripLegs.clear();
    for (var leg in response["legs"]) {

      //handle distance
      tripLegs.add(leg["distance"]["value"].toDouble());
      tempDistance += leg["distance"]["value"];

      //handle duration/time
      tempTime += leg["duration"]["value"];
    }
    _totalDistance = tempDistance;
    _totalTime = tempTime;

    updateCallback();
    notifierCallback();
  }

  //remove route
  void noRoute() {
    _polylineEncoded = "";
    _totalDistance = 0;
    _totalTime = 0;
  }

  String get polyline => _polylineEncoded;
  double get distance => _totalDistance;
  double get time => _totalTime;
}