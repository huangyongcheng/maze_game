import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Paints a radial-gradient mask of fog centered on the player.
class FogOfWarOverlay extends StatelessWidget {
  const FogOfWarOverlay({
    super.key,
    required this.center,
    required this.visibilityPx,
    required this.opacity,
  });

  /// Player position in widget-local pixels.
  final Offset center;

  /// Radius (in pixels) at which the fog reaches full opacity.
  final double visibilityPx;

  /// Animated multiplier (0 == fully revealed, 1 == fog at full strength).
  final double opacity;

  @override
  Widget build(BuildContext context) {
    if (opacity <= 0) return const SizedBox.shrink();
    return IgnorePointer(
      child: CustomPaint(
        painter: _FogPainter(
          center: center,
          visibilityPx: visibilityPx,
          opacity: opacity,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _FogPainter extends CustomPainter {
  _FogPainter({
    required this.center,
    required this.visibilityPx,
    required this.opacity,
  });

  final Offset center;
  final double visibilityPx;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.fogColor.withValues(alpha: 0),
          AppColors.fogColor.withValues(alpha: 0.2 * opacity),
          AppColors.fogColor.withValues(alpha: opacity),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: visibilityPx * 1.4));
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(covariant _FogPainter old) =>
      old.center != center ||
      old.visibilityPx != visibilityPx ||
      old.opacity != opacity;
}
