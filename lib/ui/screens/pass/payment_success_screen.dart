import 'package:flutter/material.dart';
import '../../../model/passes/pass.dart';
import '../../theme/theme.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Pass pass;
  final String label;
  final List<String> features;

  const PaymentSuccessScreen({
    super.key,
    required this.pass,
    required this.label,
    required this.features,
  });

  bool get _isSingle => pass.type == PassType.singleTicket;

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              const Spacer(),

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

              Text('Payment Successful!', style: AppTextStyles.heading1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your purchase has been confirmed.',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),

              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _isSingle
                      ? AppColors.bikeAvailable.withOpacity(0.08)
                      : AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(
                    color: _isSingle
                        ? AppColors.bikeAvailable.withOpacity(0.3)
                        : AppColors.primary.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isSingle
                              ? Icons.confirmation_number
                              : Icons.card_membership,
                          color: _isSingle
                              ? AppColors.bikeAvailable
                              : AppColors.primary,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Active: $label',
                          style: AppTextStyles.heading3.copyWith(
                            color: _isSingle
                                ? AppColors.bikeAvailable
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (!_isSingle) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(_expiryString, style: AppTextStyles.label),
                      const SizedBox(height: AppSpacing.sm),
                      ...features.map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
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
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        'Valid for a single trip',
                        style: AppTextStyles.label,
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              Text(
                _isSingle
                    ? 'Your ticket is ready.\nReturn to confirm your booking!'
                    : 'Your pass is now active.\nReturn to confirm your booking!',
                style: AppTextStyles.label,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}