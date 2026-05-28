import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';

String formatDuration(Duration d) {
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$m:$s';
}

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.totalTime,
    required this.isPaused,
    required this.isMapRevealed,
    required this.onTogglePause,
    required this.onToggleReveal,
    required this.onSettings,
  });

  final Duration totalTime;
  final bool isPaused;
  final bool isMapRevealed;
  final VoidCallback onTogglePause;
  final VoidCallback onToggleReveal;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _iconButton(
            icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            onTap: onTogglePause,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Center(
              child: Text(
                formatDuration(totalTime),
                style: AppTheme.timerStyle(),
              ),
            ),
          ),
          _iconButton(
            icon: isMapRevealed
                ? Icons.visibility_rounded
                : Icons.visibility_off_rounded,
            onTap: onToggleReveal,
          ),
          const SizedBox(width: 8),
          _iconButton(icon: Icons.settings_rounded, onTap: onSettings),
        ],
      ),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: AppColors.accentPurple.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
