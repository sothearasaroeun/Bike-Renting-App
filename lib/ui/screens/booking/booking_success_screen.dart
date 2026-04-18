import 'package:flutter/material.dart';
import '../../../model/bike/bikes.dart';
import '../../../model/booking/booking.dart';
import '../../../model/sations/sations.dart';
import '../../theme/theme.dart';
import 'widgets/booking_success_card.dart';

class BookingSuccessScreen extends StatelessWidget {
  final Booking booking;
  final Station station;
  final Bike bike;

  const BookingSuccessScreen({
    super.key,
    required this.booking,
    required this.station,
    required this.bike,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const Spacer(),

              // Orange check circle
              Container(
                width: 96,
                height: 96,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text('Booking Successful!', style: AppTextStyles.heading1),
              const SizedBox(height: AppSpacing.xl),

              BookingSuccessCard(station: station, bike: bike),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Your bike is ready to ride',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context)
                      .popUntil((route) => route.isFirst),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.label,
                  children: [
                    const TextSpan(text: 'Need help? Contact support at '),
                    TextSpan(
                      text: 'support@bikerental.com',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}