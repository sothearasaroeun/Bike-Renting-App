import 'package:flutter/material.dart';
import '../../../../model/bike/bikes.dart';
import '../../../theme/theme.dart';

class SlotListTile extends StatelessWidget {
  final Bike bike;
  final VoidCallback? onBookTap;

  const SlotListTile({super.key, required this.bike, this.onBookTap, required bool isMyBooking});

  bool get isAvailable => bike.status == BikeStatus.available;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isAvailable
                  ? AppColors.bikeAvailable.withOpacity(0.12)
                  : AppColors.bikeBooked.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.directions_bike,
              color: isAvailable
                  ? AppColors.bikeAvailable
                  : AppColors.bikeBooked,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Slot ${bike.slotNumber}', style: AppTextStyles.heading3),
                const SizedBox(height: 2),
                Text(
                  isAvailable ? 'Available bike' : 'Already booked',
                  style: AppTextStyles.label.copyWith(
                    color: isAvailable
                        ? AppColors.bikeAvailable
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Book button
          if (isAvailable)
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: onBookTap,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: const Text('Book Bike', style: TextStyle(fontSize: 13)),
              ),
            )
          else
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              alignment: Alignment.center,
              child: Text(
                'Booked',
                style: AppTextStyles.label.copyWith(color: AppColors.textHint),
              ),
            ),
        ],
      ),
    );
  }
}