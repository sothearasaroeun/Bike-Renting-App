import '../../model/passes/pass.dart';

sealed class PassState {}

class PassInitial extends PassState {}

class PassLoading extends PassState {}

class PassLoaded extends PassState {
  final Pass? activePass;
  PassLoaded(this.activePass);
}

class PassPurchasing extends PassState {}

class PassPurchaseSuccess extends PassState {
  final Pass pass;
  PassPurchaseSuccess(this.pass);
}

class PassError extends PassState {
  final String message;
  PassError(this.message);
}