import '../../model/booking/booking.dart';

sealed class BookingState {}

class BookingInitial extends BookingState {}

class BookingCheckingPass extends BookingState {}

class BookingNoPass extends BookingState {}

class BookingHasPass extends BookingState {}

class BookingSingleTicketUsed extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final Booking booking;
  BookingSuccess(this.booking);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}