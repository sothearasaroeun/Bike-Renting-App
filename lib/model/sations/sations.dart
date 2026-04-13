class Station {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int availableBikes;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.availableBikes,
  });

  @override
  String toString() {
    return 'Station(id: $id, name: $name, address: $address)';
  }

}