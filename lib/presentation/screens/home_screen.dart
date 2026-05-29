import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../domain/entities/difficulty.dart';
import '../../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../providers/score_provider.dart';
import '../widgets/game_hud.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Text(
                l10n.tagline,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _difficultyCard(
                      context: context,
                      ref: ref,
                      difficulty: Difficulty.easy,
                      label: l10n.easy,
                      stars: 1,
                      color: AppColors.homeColor,
                    ),
                    const SizedBox(height: 16),
                    _difficultyCard(
                      context: context,
                      ref: ref,
                      difficulty: Difficulty.medium,
                      label: l10n.medium,
                      stars: 2,
                      color: AppColors.accentPurple,
                    ),
                    const SizedBox(height: 16),
                    _difficultyCard(
                      context: context,
                      ref: ref,
                      difficulty: Difficulty.hard,
                      label: l10n.hard,
                      stars: 3,
                      color: AppColors.cisboxColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _difficultyCard({
    required BuildContext context,
    required WidgetRef ref,
    required Difficulty difficulty,
    required String label,
    required int stars,
    required Color color,
  }) {
    final l10n = AppLocalizations.of(context);
    final bestTime = ref.watch(bestTimeProvider(difficulty));
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        ref.read(gameProvider.notifier).startNewGame(difficulty);
        Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const GameScreen()));
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
                color: AppColors.buttonShadow,
                blurRadius: 8,
                offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Row(
              children: List.generate(
                3,
                (i) => Icon(
                  Icons.star_rounded,
                  size: 28,
                  color: i < stars
                      ? AppColors.textPrimary
                      : AppColors.textPrimary.withValues(alpha: 0.25),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.fredoka(
                          fontSize: 22, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  bestTime.when(
                    data: (d) => Text(
                      '${l10n.bestTime}: ${d == null ? l10n.noRecord : formatDuration(d)}',
                      style: GoogleFonts.fredoka(
                          fontSize: 14, color: AppColors.textPrimary.withValues(alpha: 0.8)),
                    ),
                    loading: () => const SizedBox(height: 14),
                    error: (err, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill_rounded,
                size: 36, color: AppColors.textPrimary),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.15, end: 0);
  }
}
