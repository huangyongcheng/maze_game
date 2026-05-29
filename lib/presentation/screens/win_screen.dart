import 'dart:math';

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

class WinScreen extends ConsumerWidget {
  const WinScreen({
    super.key,
    required this.totalTime,
    required this.difficulty,
    required this.wasNewRecord,
  });

  final Duration totalTime;
  final Difficulty difficulty;
  final bool wasNewRecord;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final bestAsync = ref.watch(bestTimeProvider(difficulty));
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned.fill(child: _Confetti()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.youWon,
                      style: GoogleFonts.fredoka(
                          fontSize: 28, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ).animate().scale(curve: Curves.elasticOut, duration: 600.ms),
                    const SizedBox(height: 32),
                    Text(l10n.yourTime,
                        style: GoogleFonts.fredoka(
                            fontSize: 18, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text(
                      formatDuration(totalTime),
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (wasNewRecord)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.homeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.newRecord,
                          style: GoogleFonts.fredoka(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .scale(duration: 400.ms, curve: Curves.elasticOut)
                    else
                      bestAsync.when(
                        data: (best) => Text(
                          '${l10n.bestTime}: ${best == null ? l10n.noRecord : formatDuration(best)}',
                          style: GoogleFonts.fredoka(
                              fontSize: 16,
                              color: AppColors.textSecondary),
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (err, _) => const SizedBox.shrink(),
                      ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh_rounded),
                      label: Text(l10n.playAgain),
                      onPressed: () {
                        ref
                            .read(gameProvider.notifier)
                            .startNewGame(difficulty);
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                              builder: (_) => const GameScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        ref.read(gameProvider.notifier).quit();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: Text(l10n.backToMenu),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Confetti extends StatefulWidget {
  const _Confetti();
  @override
  State<_Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<_Confetti>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = Random();
    _particles = List.generate(
      40,
      (i) => _Particle(
        x: rng.nextDouble(),
        startY: -rng.nextDouble(),
        speed: 0.3 + rng.nextDouble() * 0.5,
        size: 6 + rng.nextDouble() * 8,
        hue: rng.nextInt(5),
        spin: rng.nextDouble() * 2,
      ),
    );
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => CustomPaint(
        painter: _ConfettiPainter(
            t: _ctrl.value, particles: _particles),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.x,
    required this.startY,
    required this.speed,
    required this.size,
    required this.hue,
    required this.spin,
  });
  final double x;
  final double startY;
  final double speed;
  final double size;
  final int hue;
  final double spin;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.t, required this.particles});
  final double t;
  final List<_Particle> particles;

  static const _palette = [
    AppColors.playerColor,
    AppColors.accentPurple,
    AppColors.homeColor,
    AppColors.cisboxColor,
    Color(0xFFFFD6A5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final y = (p.startY + t * p.speed) % 1.2;
      final dy = y * size.height;
      final dx = p.x * size.width;
      final paint = Paint()..color = _palette[p.hue];
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(t * p.spin * 6.28);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size),
            Radius.circular(p.size * 0.3)),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}
