import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_track/src/features/home/data/model/location_model.dart';
import 'package:location_track/src/features/home/data/repo/location_repo.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationRepo locationRepo;
  final double tolerance = 20.0; // مدى الدقة المسموح به للموقع

  LocationCubit(this.locationRepo) : super(LocationInitial());

  // التحقق من خدمات الموقع
  Future<bool> checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(LocationFailure(message: "خدمات الموقع غير مفعلة"));
      return false;
    }
    return true;
  }

  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        emit(LocationFailure(message: "تم رفض إذن الموقع"));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      emit(LocationFailure(message: "تم رفض إذن الموقع بشكل دائم"));
      return false;
    }
    return true;
  }

  Future<void> saveLocation() async {
    try {
      emit(LocationLoading());

      if (!await checkLocationServices() || !await checkLocationPermission()) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();
      await locationRepo.saveLocation(
          latitude: position.latitude, longitude: position.longitude);

      emit(LocationSuccess(
          message: 'تم حفظ الموقع بنجاح',
          location: LocationModel(
              latitude: position.latitude, longitude: position.longitude)));
    } catch (e) {
      emit(LocationFailure(message: "فشل في حفظ الموقع: ${e.toString()}"));
    }
  }

  Future<void> loadSavedLocation() async {
    try {
      emit(LocationLoading());

      final savedLocation = await locationRepo.getLocation();
      if (savedLocation != null) {
        emit(LocationSuccess(
            location: savedLocation, message: 'تم تحميل الموقع بنجاح'));
      } else {
        emit(LocationInitial(message: "لم يتم حفظ أي موقع بعد"));
      }
    } catch (e) {
      emit(LocationFailure(message: "فشل في استرجاع الموقع: ${e.toString()}"));
    }
  }

  // التحقق من الموقع الحالي مع الموقع المحفوظ
  Future<void> checkLocation() async {
    try {
      emit(LocationLoading());

      final savedLocation = await locationRepo.getLocation();
      if (savedLocation == null) {
        emit(LocationFailure(message: "لم يتم حفظ أي موقع بعد"));
        return;
      }

      if (!await checkLocationServices() || !await checkLocationPermission()) {
        return;
      }

      // الحصول على الموقع الحالي
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double distanceInMeters = Geolocator.distanceBetween(
        savedLocation.latitude,
        savedLocation.longitude,
        currentPosition.latitude,
        currentPosition.longitude,
      );

      bool isInCorrectLocation = distanceInMeters <= tolerance;
      String message = isInCorrectLocation
          ? "أنت في الموقع الصحيح"
          : "أنت بعيد عن الموقع بمقدار ${distanceInMeters.toStringAsFixed(2)} متر";

      emit(LocationCheckSuccess(
        message: message,
        isInCorrectLocation: isInCorrectLocation,
        distance: distanceInMeters,
      ));
    } catch (e) {
      emit(
          LocationFailure(message: "فشل في التحقق من الموقع: ${e.toString()}"));
    }
  }

  // حذف الموقع المحفوظ
  Future<void> clearLocation() async {
    try {
      emit(LocationLoading());

      await locationRepo.clearLocation();
      emit(LocationInitial(message: 'تم حذف الموقع بنجاح'));
    } catch (e) {
      emit(LocationFailure(message: "فشل في حذف الموقع: ${e.toString()}"));
    }
  }
}
