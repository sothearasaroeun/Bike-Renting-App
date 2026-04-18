import 'package:flutter/foundation.dart';
import '../../../../data/repositories/stations/station_repository.dart';
import '../../../../model/bike/bikes.dart';
import '../../../../model/sations/sations.dart';
import '../../../states/station_state.dart';

class StationViewModel extends ChangeNotifier {
  final StationRepository _stationRepository;

  StationViewModel({required StationRepository stationRepository})
    : _stationRepository = stationRepository;

  StationState _state = StationInitial();
  StationState get state => _state;

  List<Bike> get bikes =>
      _state is StationLoaded ? (_state as StationLoaded).bikes : [];

  int get availableCount =>
      bikes.where((b) => b.status == BikeStatus.available).length;

  Future<void> loadStation(Station station) async {
    _state = StationLoading();
    notifyListeners();
    try {
      final bikes = await _stationRepository.getBikesAtStation(station.id);
      _state = StationLoaded(station: station, bikes: bikes);
    } catch (_) {
      _state = StationError('Failed to load bikes. Please try again.');
    }
    notifyListeners();
  }

  Future<void> refreshStation(Station station) => loadStation(station);

  Future<void> updateBikeStatus(Bike bike) async {
    await _stationRepository.updateBikeStatus(bike);

    if (_state is StationLoaded) {
      final current = _state as StationLoaded;
      final updated = current.bikes
          .map((b) => b.id == bike.id ? bike : b)
          .toList();
      _state = StationLoaded(station: current.station, bikes: updated);
      notifyListeners();
    }
  }
}