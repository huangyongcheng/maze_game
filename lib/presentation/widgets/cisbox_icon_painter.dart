import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Placeholder Cisbox office icon.
///
/// TODO: Replace with actual Cisbox logo when asset is provided.
/// To use a real logo:
///   1. Place file at assets/images/cisbox_logo.png
///   2. Enable the assets entry in pubspec.yaml under `flutter > assets`
///   3. Replace this CustomPainter usage with:
///        Image.asset('assets/images/cisbox_logo.png')
class CisboxIconPainter extends CustomPainter {
  const CisboxIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = AppColors.cisboxColor;
    final accentPaint = Paint()..color = AppColors.cisboxColor.withValues(alpha: 0.7);
    final windowPaint = Paint()..color = AppColors.background;

    // Office building base
    final body = Rect.fromLTWH(w * 0.16, h * 0.28, w * 0.68, h * 0.62);
    canvas.drawRRect(
        RRect.fromRectAndRadius(body, Radius.circular(w * 0.05)), bodyPaint);

    // Decorative top band
    final band = Rect.fromLTWH(w * 0.16, h * 0.28, w * 0.68, h * 0.08);
    canvas.drawRect(band, accentPaint);

    // Windows: 3 columns x 2 rows
    const cols = 3;
    const rows = 2;
    final winW = w * 0.13;
    final winH = h * 0.13;
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final x = w * 0.22 + c * (winW + w * 0.05);
        final y = h * 0.45 + r * (winH + h * 0.05);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(x, y, winW, winH), Radius.circular(w * 0.015)),
          windowPaint,
        );
      }
    }

    // Door
    final doorPaint = Paint()..color = AppColors.wallColor.withValues(alpha: 0.7);
    final door = Rect.fromLTWH(w * 0.45, h * 0.7, w * 0.1, h * 0.2);
    canvas.drawRRect(
        RRect.fromRectAndRadius(door, Radius.circular(w * 0.02)), doorPaint);
  }

  @override
  bool shouldRepaint(covariant CisboxIconPainter old) => false;
}
