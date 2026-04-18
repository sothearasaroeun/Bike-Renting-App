import 'package:final_project/model/passes/pass.dart';

abstract class PassRepository {
  Future<Pass?> getActivePass(String userId);
  Future<void> savePass(Pass pass);
  Future<void> markSingleTicketUsed(String userId);
}