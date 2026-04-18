import 'package:flutter/foundation.dart';
import '../../../../data/repositories/pass/pass_repository.dart';
import '../../../../model/passes/pass.dart';
import '../../../states/pass_state.dart';

const _kUserId = 'user_dev_001';

class PassViewModel extends ChangeNotifier {
  final PassRepository _passRepository;

  PassViewModel({required PassRepository passRepository})
    : _passRepository = passRepository;

  PassState _state = PassInitial();
  PassState get state => _state;

  PassType _selectedType = PassType.day;
  PassType get selectedType => _selectedType;

  Pass? get activePass =>
      _state is PassLoaded ? (_state as PassLoaded).activePass : null;

  Future<void> loadActivePass() async {
    _state = PassLoading();
    notifyListeners();
    try {
      final pass = await _passRepository.getActivePass(_kUserId);
      _state = PassLoaded(pass);
    } catch (_) {
      _state = PassError('Failed to load your pass.');
    }
    notifyListeners();
  }

  void selectType(PassType type) {
    _selectedType = type;
    notifyListeners();
  }

  Future<void> purchase(PassType type) async {
    _state = PassPurchasing();
    notifyListeners();
    try {
      final pass = Pass(
        id: 'pass_${DateTime.now().millisecondsSinceEpoch}',
        userId: _kUserId,
        type: type,
        expiryDate: _expiryFor(type),
        isActive: true,
      );
      await _passRepository.savePass(pass);
      _state = PassPurchaseSuccess(pass);
    } catch (_) {
      _state = PassError('Purchase failed. Please try again.');
    }
    notifyListeners();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String labelFor(PassType type) {
    switch (type) {
      case PassType.singleTicket:
        return 'Single Ticket';
      case PassType.day:
        return 'Day Pass';
      case PassType.monthly:
        return 'Monthly Pass';
      case PassType.annual:
        return 'Annual Pass';
    }
  }

  String priceFor(PassType type) {
    switch (type) {
      case PassType.singleTicket:
        return '\$1.50';
      case PassType.day:
        return '\$5';
      case PassType.monthly:
        return '\$29';
      case PassType.annual:
        return '\$199';
    }
  }

  String durationFor(PassType type) {
    switch (type) {
      case PassType.singleTicket:
        return 'Single trip';
      case PassType.day:
        return '24 hours';
      case PassType.monthly:
        return '30 days';
      case PassType.annual:
        return '1 year';
    }
  }

  List<String> featuresFor(PassType type) {
    switch (type) {
      case PassType.singleTicket:
        return [
          'Valid from today',
          'Single ride only',
          'Access to all stations',
        ];
      case PassType.day:
        return [
          'Valid from today',
          'Unlimited rides',
          'Access to all stations',
          '24/7 support',
        ];
      case PassType.monthly:
        return [
          'Valid from today',
          'Unlimited rides',
          'Access to all stations',
          'Priority support',
        ];
      case PassType.annual:
        return [
          'Valid from today',
          'Unlimited rides',
          'Access to all stations',
          '24/7 priority support',
        ];
    }
  }

  bool get isMostPopular => _selectedType == PassType.monthly;

  bool isMostPopularType(PassType type) => type == PassType.monthly;

  DateTime _expiryFor(PassType type) {
    final now = DateTime.now();
    switch (type) {
      case PassType.singleTicket:
        return now.add(const Duration(hours: 1));
      case PassType.day:
        return now.add(const Duration(days: 1));
      case PassType.monthly:
        return now.add(const Duration(days: 30));
      case PassType.annual:
        return now.add(const Duration(days: 365));
    }
  }
}