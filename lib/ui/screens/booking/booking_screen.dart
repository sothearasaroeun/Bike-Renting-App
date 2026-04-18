import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/bike/bikes.dart';
import '../../../model/sations/sations.dart';
import '../../states/booking_state.dart';
import '../../theme/theme.dart';
import '../pass/pass_screen.dart';
import 'booking_success_screen.dart';
import 'view_model/booking_view_model.dart';
import 'widgets/booking_slot_card.dart';

class BookingScreen extends StatefulWidget {
  final Station station;
  final Bike bike;

  const BookingScreen({super.key, required this.station, required this.bike});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    context.read<BookingViewModel>().reset();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runInit();
    });
  }

  Future<void> _runInit() async {
    await context.read<BookingViewModel>().init(
      station: widget.station,
      bike: widget.bike,
    );
  }


  Future<void> _openPassScreen(PassTypeSelection type) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PassScreen(preselectedType: type)),
    );
    if (mounted) _runInit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Bike'),
        leading: const BackButton(),
      ),
      backgroundColor: AppColors.background,
      body: Consumer<BookingViewModel>(
        builder: (context, vm, _) {
          if (vm.state is BookingSuccess && !_navigated) {
            _navigated = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingSuccessScreen(
                    booking: (vm.state as BookingSuccess).booking,
                    station: widget.station,
                    bike: widget.bike,
                  ),
                ),
              );
            });
          }

          return Column(
            children: [
              BookingSlotCard(
                station: widget.station,
                bike: widget.bike,
                hasActivePass: vm.state is BookingHasPass,
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: _buildActions(context, vm),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context, BookingViewModel vm) {
    if (vm.state is BookingInitial || vm.state is BookingCheckingPass) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.state is BookingLoading || vm.state is BookingSuccess) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: AppSpacing.md),
            Text('Confirming your booking...'),
          ],
        ),
      );
    }

    if (vm.state is BookingError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: Text(
              (vm.state as BookingError).message,
              style: AppTextStyles.body.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: vm.confirmBooking,
            child: const Text('Try Again'),
          ),
        ],
      );
    }

    if (vm.state is BookingHasPass) {
      return ElevatedButton(
        onPressed: vm.confirmBooking,
        child: const Text('Confirm Booking'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () => _openPassScreen(PassTypeSelection.single),
          child: const Text('Buy a Single Ticket'),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton(
          onPressed: () => _openPassScreen(PassTypeSelection.period),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 52),
            side: const BorderSide(color: AppColors.primary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Buy a Period-Based Pass',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}