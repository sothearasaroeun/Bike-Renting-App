import 'package:flutter/foundation.dart';
import '../../../../data/repositories/booking/booking_repository.dart';
import '../../../../data/repositories/pass/pass_repository.dart';
import '../../../../data/repositories/stations/station_repository.dart';
import '../../../../model/bike/bikes.dart';
import '../../../../model/booking/booking.dart';
import '../../../../model/passes/pass.dart';
import '../../../../model/sations/sations.dart';
import '../../../states/booking_state.dart';

const _kUserId = 'user_dev_001';

class BookingViewModel extends ChangeNotifier {
  final BookingRepository _bookingRepository;
  final StationRepository _stationRepository;
  final PassRepository _passRepository;

  BookingViewModel({
    required BookingRepository bookingRepository,
    required StationRepository stationRepository,
    required PassRepository passRepository,
  }) : _bookingRepository = bookingRepository,
       _stationRepository = stationRepository,
       _passRepository = passRepository;

  BookingState _state = BookingInitial();
  BookingState get state => _state;

  Station? _station;
  Station? get station => _station;

  Bike? _bike;
  Bike? get bike => _bike;

  Future<void> init({required Station station, required Bike bike}) async {
    _station = station;
    _bike = bike;


    _state = BookingInitial();
    notifyListeners();

    _state = BookingCheckingPass();
    notifyListeners();

    try {
      final pass = await _passRepository.getActivePass(_kUserId);
      if (pass == null || !pass.canBook) {
        _state = BookingNoPass();
      } else {
        _state = BookingHasPass();
      }
    } catch (_) {
      _state = BookingNoPass();
    }
    notifyListeners();
  }

  Future<void> confirmBooking() async {
    if (_bike == null || _station == null) return;
    _state = BookingLoading();
    notifyListeners();

    try {
      final existing = await _bookingRepository.getActiveBooking(_kUserId);
      if (existing != null) {
        final releasedBike = Bike(
          id: existing.bikeId,
          stationId: existing.stationId,
          slotNumber: _slotNumberForBike(existing.bikeId),
          status: BikeStatus.available,
        );
        await _stationRepository.updateBikeStatus(releasedBike);
        await _bookingRepository.cancelBooking(existing.id);
      }

      final booking = Booking(
        id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
        userId: _kUserId,
        bikeId: _bike!.id,
        stationId: _station!.id,
        bookedAt: DateTime.now(),
      );
      final created = await _bookingRepository.createBooking(booking);

      final updated = Bike(
        id: _bike!.id,
        stationId: _bike!.stationId,
        slotNumber: _bike!.slotNumber,
        status: BikeStatus.booked,
      );
      await _stationRepository.updateBikeStatus(updated);

      final pass = await _passRepository.getActivePass(_kUserId);
      if (pass != null && pass.type == PassType.singleTicket) {
        await _passRepository.markSingleTicketUsed(_kUserId);
      }

      _state = BookingSuccess(created);
    } catch (_) {
      _state = BookingError('Booking failed. Please try again.');
    }
    notifyListeners();
  }

  void reset() {
    _state = BookingInitial();
    _station = null;
    _bike = null;
    notifyListeners();
  }

  int _slotNumberForBike(String bikeId) {
    final parts = bikeId.split('_');
    if (parts.length >= 3) return int.tryParse(parts.last) ?? 1;
    return 1;
  }
}