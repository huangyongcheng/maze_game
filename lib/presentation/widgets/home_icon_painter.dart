import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Cute house with triangle roof, square body, chimney + curly smoke. Gently
/// glows via [glowPhase] (0..1).
class HomeIconPainter extends CustomPainter {
  HomeIconPainter({required this.glowPhase});
  final double glowPhase;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Glow halo
    final glow = 0.5 + 0.5 * sin(glowPhase * 2 * pi);
    final glowPaint = Paint()
      ..color = AppColors.homeColor.withValues(alpha: 0.25 * glow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.5, glowPaint);

    final bodyPaint = Paint()..color = AppColors.homeColor;
    final roofPaint = Paint()..color = AppColors.homeColor.withValues(alpha: 0.85);

    // Body
    final body = Rect.fromLTWH(w * 0.2, h * 0.45, w * 0.6, h * 0.42);
    canvas.drawRRect(
        RRect.fromRectAndRadius(body, Radius.circular(w * 0.05)), bodyPaint);

    // Roof
    final roof = Path()
      ..moveTo(w * 0.1, h * 0.5)
      ..lineTo(w * 0.5, h * 0.18)
      ..lineTo(w * 0.9, h * 0.5)
      ..close();
    canvas.drawPath(roof, roofPaint);

    // Chimney
    final chimney = Rect.fromLTWH(w * 0.66, h * 0.25, w * 0.08, h * 0.16);
    canvas.drawRect(chimney, roofPaint);

    // Door
    final door = Paint()..color = AppColors.wallColor.withValues(alpha: 0.75);
    final doorRect = Rect.fromLTWH(w * 0.42, h * 0.6, w * 0.16, h * 0.27);
    canvas.drawRRect(
        RRect.fromRectAndRadius(doorRect, Radius.circular(w * 0.04)), door);
  }

  @override
  bool shouldRepaint(covariant HomeIconPainter old) =>
      old.glowPhase != glowPhase;
}
