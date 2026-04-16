import '../../../model/bike/bikes.dart';
import '../../../model/sations/sations.dart';
import 'station_repository.dart';

class MockStationRepository implements StationRepository {
  final List<Station> _stations = [
    Station(
      id: 's1',
      name: 'Independence Monument',
      address: 'Sihanouk Blvd',
      latitude: 11.5564,
      longitude: 104.9282,
      availableBikes: 8,
    ),
    Station(
      id: 's2',
      name: 'Central Market',
      address: 'Kampuchea Krom Blvd',
      latitude: 11.5683,
      longitude: 104.9230,
      availableBikes: 4,
    ),
    Station(
      id: 's3',
      name: 'Royal Palace',
      address: 'Samdech Sothearos Blvd',
      latitude: 11.5626,
      longitude: 104.9306,
      availableBikes: 6,
    ),
  ];

  final List<Bike> _bikes = [
    ...List.generate(9, (i) {
      return Bike(
        id: 'b_s1_${i + 1}',
        stationId: 's1',
        slotNumber: i + 1,
        status: i < 8 ? BikeStatus.available : BikeStatus.booked,
      );
    }),
    ...List.generate(5, (i) {
      return Bike(
        id: 'b_s2_${i + 1}',
        stationId: 's2',
        slotNumber: i + 1,
        status: i < 4 ? BikeStatus.available : BikeStatus.booked,
      );
    }),
    ...List.generate(7, (i) {
      return Bike(
        id: 'b_s3_${i + 1}',
        stationId: 's3',
        slotNumber: i + 1,
        status: i < 6 ? BikeStatus.available : BikeStatus.booked,
      );
    }),
  ];

  @override
  Future<List<Station>> getStations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _stations.map((station) {
      final availableCount = _bikes
          .where(
            (b) =>
                b.stationId == station.id && b.status == BikeStatus.available,
          )
          .length;

      return Station(
        id: station.id,
        name: station.name,
        address: station.address,
        latitude: station.latitude,
        longitude: station.longitude,
        availableBikes: availableCount,
      );    
      }).toList();
  }

  @override
  Future<List<Bike>> getBikesAtStation(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _bikes.where((b) => b.stationId == stationId).toList();
  }

  @override
  Future<void> updateBikeStatus(Bike bike) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _bikes.indexWhere((b) => b.id == bike.id);
    if (index != -1) {
      _bikes[index] = bike;
    }
  }
}