class Booking {
  final String id;
  final String userId;
  final String bikeId;
  final String stationId;
  final DateTime bookedAt;

  Booking({
    required this.id,
    required this.userId,
    required this.bikeId,
    required this.stationId,
    required this.bookedAt,
  });

}