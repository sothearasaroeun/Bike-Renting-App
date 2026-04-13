import '../../../model/bike/bikes.dart';
import '../../../model/sations/sations.dart';

abstract class StationRepository {
  Future<List<Station>> getStations();
  Future<List<Bike>> getBikesAtStation(String stationId);
  Future<void> updateBikeStatus(Bike bike);
}
