import '../../model/sations/sations.dart';

sealed class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<Station> stations;
  MapLoaded(this.stations);
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}