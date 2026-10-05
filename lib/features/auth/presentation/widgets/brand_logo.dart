import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../login_style.dart';

/// نشان برند: حلقه‌ی گرادیانی آبی→بنفش با دنباله، نزدیک‌ترین شکل به لوگوی طرح.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = LoginSizes.logoSize});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('brandLogo'),
      width: size,
      height: size,
      child: CustomPaint(painter: _BrandLogoPainter()),
    );
  }
}

class _BrandLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final shader = LoginColors.logoGradient.createShader(
      Offset.zero & size,
    );
    final stroke = size.width * 0.24;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2 - size.width * 0.04;

    final ring = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    // حلقه از ساعت ۱۲ در جهت ساعتگرد تا حدود ساعت ۴، سپس دنباله به سمت مرکز.
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2, math.pi * 1.55, false, ring);

    final tail = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx + radius, center.dy + stroke * 0.2),
      Offset(center.dx + stroke * 0.1, center.dy + stroke * 0.2),
      tail,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
