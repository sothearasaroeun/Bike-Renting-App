import '../../model/bike/bikes.dart';
import '../../model/sations/sations.dart';

sealed class StationState {}

class StationInitial extends StationState {}

class StationLoading extends StationState {}

class StationLoaded extends StationState {
  final Station station;
  final List<Bike> bikes;
  StationLoaded({required this.station, required this.bikes});
}

class StationError extends StationState {
  final String message;
  StationError(this.message);
}