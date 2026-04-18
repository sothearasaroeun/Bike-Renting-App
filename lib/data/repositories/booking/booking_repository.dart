import 'package:final_project/model/booking/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking(Booking booking);
  Future<Booking?> getActiveBooking(String userId);
  Future<void> cancelBooking(String bookingId);
}