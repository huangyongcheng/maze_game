import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Briefly slides in a "+30s" indicator at the top of the screen.
class RevealPenaltyToast extends StatelessWidget {
  const RevealPenaltyToast({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.playerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: AppColors.buttonShadow, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Text(
        l10n.revealMapPenalty,
        style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16),
      ),
    )
        .animate()
        .moveY(begin: -40, end: 0, duration: 250.ms, curve: Curves.easeOut)
        .fadeIn(duration: 250.ms)
        .then(delay: 700.ms)
        .fadeOut(duration: 300.ms);
  }
}
