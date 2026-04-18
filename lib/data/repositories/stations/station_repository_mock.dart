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
      availableBikes: 9,
    ),
    Station(
      id: 's2',
      name: 'Central Market',
      address: 'Kampuchea Krom Blvd',
      latitude: 11.5683,
      longitude: 104.9230,
      availableBikes: 5,
    ),
    Station(
      id: 's3',
      name: 'Royal Palace',
      address: 'Samdech Sothearos Blvd',
      latitude: 11.5626,
      longitude: 104.9306,
      availableBikes: 7,
    ),
    Station(
      id: 's4',
      name: 'Wat Phnom',
      address: 'Street 94',
      latitude: 11.5735,
      longitude: 104.9288,
      availableBikes: 6,
    ),
    Station(
      id: 's5',
      name: 'Aeon Mall 1',
      address: 'Samdech Sothearos Blvd',
      latitude: 11.5486,
      longitude: 104.9297,
      availableBikes: 8,
    ),
    Station(
      id: 's6',
      name: 'Olympic Stadium',
      address: 'Street 215',
      latitude: 11.5522,
      longitude: 104.9143,
      availableBikes: 4,
    ),
    Station(
      id: 's7',
      name: 'Russian Market',
      address: 'Street 444',
      latitude: 11.5417,
      longitude: 104.9160,
      availableBikes: 5,
    ),
  ];

  final List<Bike> _bikes = [
    ...List.generate(
      9,
      (i) => Bike(
        id: 'b_s1_${i + 1}',
        stationId: 's1',
        slotNumber: i + 1,
        status: BikeStatus.available,
      ),
    ),
    ...List.generate(
      5,
      (i) => Bike(
        id: 'b_s2_${i + 1}',
        stationId: 's2',
        slotNumber: i + 1,
        status: BikeStatus.available,
      ),
    ),
    ...List.generate(
      7,
      (i) => Bike(
        id: 'b_s3_${i + 1}',
        stationId: 's3',
        slotNumber: i + 1,
        status: BikeStatus.available,
      ),
    ),
    ...List.generate(
      6,
      (i) => Bike(
        id: 'b_s4_${i + 1}',
        stationId: 's4',
        slotNumber: i + 1,
        status: BikeStatus.available,
      ),
    ),
    ...List.generate(
      8,
      (i) => Bike(
        id: 'b_s5_${i + 1}',
        stationId: 's5',
        slotNumber: i + 1,
        status: BikeStatus.available,
      ),
    ),
    ...List.generate(
      4,
      (i) => Bike(
        id: 'b_s6_${i + 1}',
        stationId: 's6',
        slotNumber: i + 1,
        status: BikeStatus.available,
      ),
    ),
    ...List.generate(
      5,
      (i) => Bike(
        id: 'b_s7_${i + 1}',
        stationId: 's7',
        slotNumber: i + 1,
        status: BikeStatus.available,
      ),
    ),
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