import 'package:flutter/material.dart';
import '../../../../model/passes/pass.dart';
import '../../../theme/theme.dart';

class ActivePassCard extends StatelessWidget {
  final Pass pass;
  final String label;
  final List<String> features;

  const ActivePassCard({
    super.key,
    required this.pass,
    required this.label,
    required this.features,
  });

  String get _expiryString {
    final e = pass.expiryDate;
    return 'Expires: ${_month(e.month)} ${e.day}, ${e.year} at ${_time(e)}';
  }

  String _month(int m) => const [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ][m];

  String _time(DateTime d) {
    final h = d.hour > 12
        ? d.hour - 12
        : d.hour == 0
        ? 12
        : d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final period = d.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Active badge row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.bikeAvailable.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.circle,
                      color: AppColors.bikeAvailable,
                      size: 8,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Valid until',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.bikeAvailable,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(_expiryString, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.md),
          Text(label, style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.sm),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.bikeAvailable,
                    size: 14,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(f, style: AppTextStyles.label),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}