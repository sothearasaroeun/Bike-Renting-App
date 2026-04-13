enum BikeStatus { available, booked }

class Bike {
  final String id;
  final String stationId;
  final int slotNumber;
  final BikeStatus status;

  Bike({
    required this.id,
    required this.stationId,
    required this.slotNumber,
    required this.status,
  });

  @override
  String toString() {
    return 'Bike(id: $id, stationId: $stationId, slot: $slotNumber, status: $status)';
  }
}