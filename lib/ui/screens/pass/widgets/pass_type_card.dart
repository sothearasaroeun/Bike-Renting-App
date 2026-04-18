import 'package:flutter/material.dart';
import '../../../../model/passes/pass.dart';
import '../../../theme/theme.dart';

class PassTypeCard extends StatelessWidget {
  final PassType type;
  final String label;
  final String price;
  final String duration;
  final List<String> features;
  final bool isMostPopular;
  final bool isLoading;
  final VoidCallback onSelect;

  const PassTypeCard({
    super.key,
    required this.type,
    required this.label,
    required this.price,
    required this.duration,
    required this.features,
    required this.onSelect,
    this.isMostPopular = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(label, style: AppTextStyles.heading2),
                          if (isMostPopular) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.bikeAvailable,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Most Popular',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(price, style: AppTextStyles.price),
                          const SizedBox(width: 4),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '/ $duration',
                              style: AppTextStyles.bodySecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(
            color: AppColors.divider,
            height: 1,
            indent: AppSpacing.md,
            endIndent: AppSpacing.md,
          ),

          // Features list
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                ...features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs + 2),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.bikeAvailable,
                          size: 16,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(f, style: AppTextStyles.bodySecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : onSelect,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text('Select $label'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}