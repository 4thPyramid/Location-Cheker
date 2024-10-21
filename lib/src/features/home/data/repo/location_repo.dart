import 'package:location_track/src/features/home/data/model/location_model.dart';

abstract class LocationRepo {
  Future<void> saveLocation({
    required double latitude,
    required double longitude,
  });
  Future<LocationModel?> getLocation();
  Future<void> clearLocation();
}
