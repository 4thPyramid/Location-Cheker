import 'package:location_track/src/features/home/data/model/location_model.dart';
import 'package:location_track/src/features/home/data/repo/location_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepoImplementation implements LocationRepo {
  final String _latitudeKey = 'latitude';
  final String _longitudeKey = 'longitude';

  @override
  Future<void> saveLocation(
      {required double latitude, required double longitude}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_latitudeKey, latitude);
    await prefs.setDouble(_longitudeKey, longitude);
  }

  @override
  Future<LocationModel?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final latitude = prefs.getDouble(_latitudeKey);
    final longitude = prefs.getDouble(_longitudeKey);

    if (latitude != null && longitude != null) {
      return LocationModel(latitude: latitude, longitude: longitude);
    }
    return null;
  }

  @override
  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_latitudeKey);
    await prefs.remove(_longitudeKey);
  }
}
