import 'package:flutter/material.dart';

import '../exam_style.dart';

/// نوار پیشرفت آزمون؛ پرشدگی از سمت چپ شروع می‌شود، مطابق طرح.
class ExamProgressBar extends StatelessWidget {
  const ExamProgressBar({
    super.key,
    required this.value,
    this.trackColor = ExamColors.progressTrack,
  });

  final double value;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ExamSizes.progressHeight,
      child: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: trackColor,
                  borderRadius:
                      BorderRadius.circular(ExamSizes.progressHeight / 2),
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: constraints.maxWidth * value.clamp(0.0, 1.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8A5BE6), ExamColors.purple],
                  ),
                  borderRadius:
                      BorderRadius.circular(ExamSizes.progressHeight / 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
