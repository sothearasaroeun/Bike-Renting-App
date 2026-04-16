import 'package:final_project/model/booking/booking.dart';
import 'booking_repository.dart';

class MockBookingRepository implements BookingRepository {
  final List<Booking> _bookings = [];

  @override
  Future<Booking> createBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _bookings.add(booking);
    return booking;
  }

  @override
  Future<Booking?> getActiveBooking(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _bookings.lastWhere((b) => b.userId == userId);
    } catch (_) {
      return null;
    }
  }
}