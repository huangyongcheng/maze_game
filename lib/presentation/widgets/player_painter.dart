import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/direction.dart';

/// Chibi character: round body, eyes, smile. Tilts in the facing direction
/// and bobs subtly via [bobPhase].
class PlayerPainter extends CustomPainter {
  PlayerPainter({required this.facing, required this.bobPhase});

  final Direction facing;
  final double bobPhase; // 0..1, animated continuously

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.36;
    final bobOffset = sin(bobPhase * 2 * pi) * size.height * 0.04;

    // Tilt: rotate slightly toward facing direction.
    canvas.save();
    canvas.translate(center.dx, center.dy + bobOffset);
    final tilt = _tiltFor(facing);
    canvas.rotate(tilt);

    // Body shadow.
    final shadow = Paint()
      ..color = AppColors.buttonShadow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(0, radius * 0.18), radius * 0.9, shadow);

    // Body.
    final body = Paint()..color = AppColors.playerColor;
    canvas.drawCircle(Offset.zero, radius, body);

    // Cheeks.
    final cheek = Paint()..color = AppColors.accentPurple.withValues(alpha: 0.5);
    canvas.drawCircle(Offset(-radius * 0.45, radius * 0.18), radius * 0.13, cheek);
    canvas.drawCircle(Offset(radius * 0.45, radius * 0.18), radius * 0.13, cheek);

    // Eyes.
    final eye = Paint()..color = AppColors.textPrimary;
    canvas.drawCircle(Offset(-radius * 0.28, -radius * 0.1), radius * 0.08, eye);
    canvas.drawCircle(Offset(radius * 0.28, -radius * 0.1), radius * 0.08, eye);

    // Smile.
    final smilePaint = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.07
      ..strokeCap = StrokeCap.round;
    final smileRect = Rect.fromCenter(
      center: Offset(0, radius * 0.25),
      width: radius * 0.45,
      height: radius * 0.3,
    );
    canvas.drawArc(smileRect, 0.2, pi - 0.4, false, smilePaint);

    canvas.restore();
  }

  double _tiltFor(Direction d) {
    switch (d) {
      case Direction.east:
        return 0.15;
      case Direction.west:
        return -0.15;
      case Direction.north:
        return 0;
      case Direction.south:
        return 0;
    }
  }

  @override
  bool shouldRepaint(covariant PlayerPainter old) =>
      old.facing != facing || old.bobPhase != bobPhase;
}
