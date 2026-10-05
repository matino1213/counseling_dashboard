import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_sizes.dart';
import '../exam_style.dart';

/// نوار راهنمایی مشاور در پایین صفحه.
class ExamConsultationStrip extends StatelessWidget {
  const ExamConsultationStrip({super.key, required this.onContact});

  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ExamSizes.stripHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      decoration: BoxDecoration(
        color: ExamColors.stripBackground,
        borderRadius: BorderRadius.circular(ExamSizes.stripRadius),
      ),
      child: Row(
        children: [
          const Icon(Icons.support_agent, size: 24, color: ExamColors.ink),
          const SizedBox(width: AppSizes.md),
          const Expanded(
            child: Text(
              'برای بررسی نتایج، از مشاور خود راهنمایی بگیرید.',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ExamSizes.stripTextSize,
                fontWeight: FontWeight.w600,
                color: ExamColors.ink,
              ),
            ),
          ),
          const SizedBox(width: AppSizes.md),
          OutlinedButton.icon(
            onPressed: onContact,
            icon:
                const Icon(Icons.support_agent, size: AppSizes.buttonIconSize),
            label: const Text('ارتباط با مشاور'),
            style: OutlinedButton.styleFrom(
              backgroundColor: ExamColors.surface,
              foregroundColor: ExamColors.ink,
              minimumSize: const Size(0, ExamSizes.buttonHeight),
              maximumSize: const Size(double.infinity, ExamSizes.buttonHeight),
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
              side: const BorderSide(color: AppColors.borderStrong),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ExamSizes.buttonRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
