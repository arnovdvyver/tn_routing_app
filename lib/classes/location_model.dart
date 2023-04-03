
//class of a Location Model
class LocationModel {
  final String locationName, placeId, address;
  Map geoPoints;
  double distancePartition = 0;

  //constructor
  LocationModel(this.locationName, this.placeId, this.geoPoints, this.address);


  //default constructor
  void setDistancePartition(double value) {
    distancePartition = value;
  }


  //getters
  String get name => locationName;
  String get id => placeId;
  String get fullAddress => address;
  double get partition => distancePartition;
  Map get geo => geoPoints;
}