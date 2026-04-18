import '../../../model/passes/pass.dart';
import 'pass_repository.dart';

class MockPassRepository implements PassRepository {
  Pass? _activePass;

  @override
  Future<Pass?> getActivePass(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_activePass == null) return null;
    if (_activePass!.userId != userId) return null;
    if (_activePass!.expiryDate.isBefore(DateTime.now())) {
      _activePass = null;
      return null;
    }
    return _activePass;
  }

  @override
  Future<void> savePass(Pass pass) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _activePass = pass;
  }

  @override
  Future<void> markSingleTicketUsed(String userId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (_activePass != null &&
        _activePass!.userId == userId &&
        _activePass!.type == PassType.singleTicket) {
      _activePass = _activePass!.copyWith(isUsed: true);
    }
  }
}