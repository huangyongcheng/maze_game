import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/direction.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/game_session.dart';
import '../providers/game_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/cisbox_icon_painter.dart';
import '../widgets/d_pad_controls.dart';
import '../widgets/fog_of_war_overlay.dart';
import '../widgets/game_hud.dart';
import '../widgets/home_icon_painter.dart';
import '../widgets/maze_painter.dart';
import '../widgets/pause_overlay.dart';
import '../widgets/player_painter.dart';
import '../widgets/reveal_penalty_toast.dart';
import 'settings_screen.dart';
import 'win_screen.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bobController;
  late final AnimationController _fogController;

  // For the penalty toast.
  int _lastRevealCount = 0;
  bool _showPenaltyToast = false;

  @override
  void initState() {
    super.initState();
    _bobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _fogController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: const Duration(milliseconds: AppDimensions.fogToggleMs),
    );
  }

  @override
  void dispose() {
    _bobController.dispose();
    _fogController.dispose();
    super.dispose();
  }

  void _handleMove(Direction d, GameSession session) {
    if (session.status != GameStatus.playing) return;
    ref.read(gameProvider.notifier).move(d);
  }

  void _onRevealToggle(GameSession session) {
    final wasRevealed = session.isMapRevealed;
    ref.read(gameProvider.notifier).toggleReveal();
    if (!wasRevealed) {
      // Reveal: fog fades out, show penalty toast.
      _fogController.reverse();
      setState(() {
        _showPenaltyToast = true;
        _lastRevealCount = session.mapRevealCount + 1;
      });
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) setState(() => _showPenaltyToast = false);
      });
    } else {
      _fogController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(gameProvider);
    final settings = ref.watch(settingsProvider);

    ref.listen<GameSession?>(gameProvider, (prev, next) {
      if (next != null &&
          next.status == GameStatus.won &&
          prev?.status != GameStatus.won) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => WinScreen(
                totalTime: next.totalTime,
                difficulty: next.difficulty,
                wasNewRecord: next.wasNewRecord,
              ),
            ),
          );
        });
      }
    });

    if (session == null) {
      // Defensive: route was opened without a game in progress.
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    _lastRevealCount = session.mapRevealCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                GameHud(
                  totalTime: session.totalTime,
                  isPaused: session.isPaused,
                  isMapRevealed: session.isMapRevealed,
                  onTogglePause: () =>
                      ref.read(gameProvider.notifier).togglePause(),
                  onToggleReveal: () => _onRevealToggle(session),
                  onSettings: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const SettingsScreen())),
                ),
                Expanded(child: _MazeArea(
                  session: session,
                  bobController: _bobController,
                  fogController: _fogController,
                  onSwipe: settings.swipeEnabled
                      ? (d) => _handleMove(d, session)
                      : null,
                  difficulty: session.difficulty,
                )),
                const SizedBox(height: 8),
                if (settings.dpadEnabled)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: DPadControls(
                      enabled: session.status == GameStatus.playing,
                      onMove: (d) => _handleMove(d, session),
                    ),
                  ),
              ],
            ),
            if (session.isPaused)
              PauseOverlay(
                onResume: () => ref.read(gameProvider.notifier).togglePause(),
                onQuit: () {
                  ref.read(gameProvider.notifier).quit();
                  Navigator.of(context).popUntil((r) => r.isFirst);
                },
              ),
            if (_showPenaltyToast)
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  key: ValueKey('penalty_$_lastRevealCount'),
                  child: const RevealPenaltyToast(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MazeArea extends StatelessWidget {
  const _MazeArea({
    required this.session,
    required this.bobController,
    required this.fogController,
    required this.onSwipe,
    required this.difficulty,
  });

  final GameSession session;
  final AnimationController bobController;
  final AnimationController fogController;
  final void Function(Direction)? onSwipe;
  final Difficulty difficulty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: AspectRatio(
        aspectRatio: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cellSize = constraints.maxWidth / session.maze.width;
            return GestureDetector(
              onPanEnd: onSwipe == null
                  ? null
                  : (details) {
                      final v = details.velocity.pixelsPerSecond;
                      if (v.distance < 200) return;
                      if (v.dx.abs() > v.dy.abs()) {
                        onSwipe!(v.dx > 0 ? Direction.east : Direction.west);
                      } else {
                        onSwipe!(v.dy > 0 ? Direction.south : Direction.north);
                      }
                    },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(painter: MazePainter(maze: session.maze)),
                  ),
                  // Home icon at start
                  Positioned(
                    left: session.maze.start.x * cellSize,
                    top: session.maze.start.y * cellSize,
                    width: cellSize,
                    height: cellSize,
                    child: AnimatedBuilder(
                      animation: bobController,
                      builder: (context, _) => CustomPaint(
                        painter:
                            HomeIconPainter(glowPhase: bobController.value),
                      ),
                    ),
                  ),
                  // Cisbox office at end
                  Positioned(
                    left: session.maze.end.x * cellSize,
                    top: session.maze.end.y * cellSize,
                    width: cellSize,
                    height: cellSize,
                    child: const CustomPaint(
                      painter: CisboxIconPainter(),
                    ),
                  ),
                  // Player
                  AnimatedPositioned(
                    duration: const Duration(
                        milliseconds: AppDimensions.playerMoveMs),
                    curve: Curves.easeOutCubic,
                    left: session.player.position.x * cellSize,
                    top: session.player.position.y * cellSize,
                    width: cellSize,
                    height: cellSize,
                    child: AnimatedBuilder(
                      animation: bobController,
                      builder: (context, _) => CustomPaint(
                        painter: PlayerPainter(
                          facing: session.player.facing,
                          bobPhase: bobController.value,
                        ),
                      ),
                    ),
                  ),
                  // Fog of war
                  AnimatedBuilder(
                    animation: fogController,
                    builder: (context, _) {
                      final fogOpacity =
                          session.isMapRevealed ? 0.0 : fogController.value;
                      return Positioned.fill(
                        child: FogOfWarOverlay(
                          center: Offset(
                            session.player.position.x * cellSize +
                                cellSize / 2,
                            session.player.position.y * cellSize +
                                cellSize / 2,
                          ),
                          visibilityPx:
                              difficulty.visibilityRadius * cellSize,
                          opacity: fogOpacity,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
