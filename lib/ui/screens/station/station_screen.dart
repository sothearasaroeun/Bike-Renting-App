import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/booking/booking_repository.dart';
import '../../../model/bike/bikes.dart';
import '../../../model/sations/sations.dart';
import '../../states/station_state.dart';
import '../../theme/theme.dart';
import '../booking/booking_screen.dart';
import 'view_model/station_view_model.dart';
import 'widgets/slot_list_tile.dart';

class StationScreen extends StatefulWidget {
  final Station station;
  const StationScreen({super.key, required this.station});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  String? _activeBookingBikeId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<StationViewModel>();
      await vm.loadStation(widget.station);

      final bookingRepo = context.read<BookingRepository>();
      final existing = await bookingRepo.getActiveBooking('user_dev_001');
      if (mounted) {
        setState(() {
          _activeBookingBikeId = existing?.bikeId;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Station Info'),
        leading: const BackButton(),
      ),
      backgroundColor: AppColors.background,
      body: Consumer<StationViewModel>(
        builder: (context, vm, _) {
          if (vm.state is StationLoading || vm.state is StationInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.state is StationError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    (vm.state as StationError).message,
                    style: AppTextStyles.bodySecondary,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => vm.loadStation(widget.station),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.directions_bike,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.station.name,
                            style: AppTextStyles.heading2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.station.address,
                            style: AppTextStyles.bodySecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Available Bikes: ${vm.availableCount}',
                            style: AppTextStyles.label.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Slot list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: vm.bikes.length,
                  itemBuilder: (context, index) {
                    final bike = vm.bikes[index];

                    final isMyBooking = bike.id == _activeBookingBikeId;

                    final displayStatus = isMyBooking
                        ? BikeStatus.booked
                        : bike.status;

                    return SlotListTile(
                      bike: bike.status == bike.status
                          ? Bike(
                              id: bike.id,
                              stationId: bike.stationId,
                              slotNumber: bike.slotNumber,
                              status: displayStatus,
                            )
                          : bike,
                      isMyBooking: isMyBooking,
                      onBookTap:
                          bike.status == BikeStatus.available && !isMyBooking
                          ? () =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookingScreen(
                                      station: widget.station,
                                      bike: bike,
                                    ),
                                  ),
                                ).then((_) async {
                                  await vm.loadStation(widget.station);

                                  final bookingRepo = context
                                      .read<BookingRepository>();
                                  final existing = await bookingRepo
                                      .getActiveBooking('user_dev_001');
                                  if (mounted) {
                                    setState(() {
                                      _activeBookingBikeId = existing?.bikeId;
                                    });
                                  }
                                })
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}