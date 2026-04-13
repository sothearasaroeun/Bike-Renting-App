enum PassType { singleTicket, day, monthly, annual }

class Pass {
  final String id;
  final String userId;
  final PassType type;
  final DateTime expiryDate;
  final bool isActive;

  Pass({
    required this.id,
    required this.userId,
    required this.type,
    required this.expiryDate,
    required this.isActive,
  });

}