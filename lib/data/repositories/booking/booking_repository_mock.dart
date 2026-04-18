import '../../../model/booking/booking.dart';
import '../../../model/bike/bikes.dart';
import 'booking_repository.dart';

class MockBookingRepository implements BookingRepository {
  Booking? _activeBooking;

  @override
  Future<Booking> createBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _activeBooking = booking;
    return booking;
  }

  @override
  Future<Booking?> getActiveBooking(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_activeBooking?.userId == userId) return _activeBooking;
    return null;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (_activeBooking?.id == bookingId) {
      _activeBooking = null;
    }
  }
}