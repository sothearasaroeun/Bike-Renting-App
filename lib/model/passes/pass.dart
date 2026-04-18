enum PassType { singleTicket, day, monthly, annual }

class Pass {
  final String id;
  final String userId;
  final PassType type;
  final DateTime expiryDate;
  final bool isActive;
  final bool isUsed;

  Pass({
    required this.id,
    required this.userId,
    required this.type,
    required this.expiryDate,
    required this.isActive,
    this.isUsed = false,
  });

  Pass copyWith({
    String? id,
    String? userId,
    PassType? type,
    DateTime? expiryDate,
    bool? isActive,
    bool? isUsed,
  }) {
    return Pass(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      isUsed: isUsed ?? this.isUsed,
    );
  }

  bool get canBook {
    if (expiryDate.isBefore(DateTime.now())) return false;
    if (type == PassType.singleTicket && isUsed) return false;
    return true;
  }
}