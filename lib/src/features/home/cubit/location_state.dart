part of 'location_cubit.dart';

sealed class LocationState {}

final class LocationInitial extends LocationState {
  final String message;

  LocationInitial({this.message = "لم يتم حفظ الموقع بعد"});
}

final class LocationLoading extends LocationState {}

final class LocationSuccess extends LocationState {
  final String message;
  final LocationModel location;

  LocationSuccess({required this.message, required this.location});
}

final class LocationFailure extends LocationState {
  final String message;

  LocationFailure({required this.message});
}

final class LocationCheckSuccess extends LocationState {
  final bool isInCorrectLocation;
  final double distance;
  final String message;
  LocationCheckSuccess(
      {required this.isInCorrectLocation,
      required this.distance,
      required this.message});
}
