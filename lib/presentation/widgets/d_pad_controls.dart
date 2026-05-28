import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/direction.dart';

/// 4-direction control pad.
class DPadControls extends StatelessWidget {
  const DPadControls({super.key, required this.onMove, this.enabled = true});

  final void Function(Direction) onMove;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _arrow(Icons.arrow_drop_up, Direction.north),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _arrow(Icons.arrow_left, Direction.west),
            const SizedBox(width: 56),
            _arrow(Icons.arrow_right, Direction.east),
          ],
        ),
        _arrow(Icons.arrow_drop_down, Direction.south),
      ],
    );
  }

  Widget _arrow(IconData icon, Direction dir) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Material(
        color: enabled ? AppColors.accentPurple : AppColors.accentPurple.withValues(alpha: 0.4),
        shape: const CircleBorder(),
        elevation: 3,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? () => onMove(dir) : null,
          child: SizedBox(
            width: 56,
            height: 56,
            child: Icon(icon, size: 40, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
