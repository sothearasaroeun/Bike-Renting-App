import 'package:flutter/foundation.dart';

import '../../../../data/repositories/stations/station_repository.dart';
import '../../../../model/sations/sations.dart';
import '../../../states/map_state.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository _stationRepository;

  MapViewModel({required StationRepository stationRepository})
    : _stationRepository = stationRepository;

  MapState _state = MapInitial();
  MapState get state => _state;

  List<Station> get stations =>
      _state is MapLoaded ? (_state as MapLoaded).stations : [];

  Future<void> loadStations() async {
    _state = MapLoading();
    notifyListeners();
    try {
      final stations = await _stationRepository.getStations();
      _state = MapLoaded(stations);
    } catch (_) {
      _state = MapError('Failed to load stations. Please try again.');
    }
    notifyListeners();
  }
}