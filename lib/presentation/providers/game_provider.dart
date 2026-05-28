import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_dimensions.dart';
import '../../core/utils/audio_manager.dart';
import '../../data/repositories/maze_repository_impl.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/direction.dart';
import '../../domain/entities/game_session.dart';
import '../../domain/entities/player.dart';
import '../../domain/repositories/maze_repository.dart';
import '../../domain/usecases/check_win_usecase.dart';
import '../../domain/usecases/generate_maze_usecase.dart';
import '../../domain/usecases/move_player_usecase.dart';
import '../../domain/usecases/reveal_map_usecase.dart';
import 'score_provider.dart';

final mazeRepositoryProvider =
    Provider<MazeRepository>((ref) => MazeRepositoryImpl());

final generateMazeUsecaseProvider = Provider<GenerateMazeUsecase>(
    (ref) => GenerateMazeUsecase(ref.watch(mazeRepositoryProvider)));

final movePlayerUsecaseProvider =
    Provider<MovePlayerUsecase>((ref) => const MovePlayerUsecase());

final checkWinUsecaseProvider =
    Provider<CheckWinUsecase>((ref) => const CheckWinUsecase());

final revealMapUsecaseProvider =
    Provider<RevealMapUsecase>((ref) => const RevealMapUsecase());

class GameNotifier extends StateNotifier<GameSession?> {
  GameNotifier(this._ref) : super(null);

  final Ref _ref;
  Timer? _ticker;

  void startNewGame(Difficulty difficulty) {
    _ticker?.cancel();
    final maze = _ref.read(generateMazeUsecaseProvider)(difficulty);
    state = GameSession(
      maze: maze,
      player: Player(position: maze.start),
      difficulty: difficulty,
      elapsedTime: Duration.zero,
      penaltyTime: Duration.zero,
      isMapRevealed: false,
      mapRevealCount: 0,
      status: GameStatus.playing,
    );
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(
        const Duration(milliseconds: AppDimensions.timerTickMs), (_) {
      final current = state;
      if (current == null || current.status != GameStatus.playing) return;
      state = current.copyWith(
        elapsedTime: current.elapsedTime +
            const Duration(milliseconds: AppDimensions.timerTickMs),
      );
    });
  }

  void move(Direction direction) {
    final current = state;
    if (current == null || current.status != GameStatus.playing) return;
    final result = _ref.read(movePlayerUsecaseProvider)(
      maze: current.maze,
      player: current.player,
      direction: direction,
    );

    if (result.movedThroughWall) {
      AudioManager.instance.play(GameSound.wallBump);
      state = current.copyWith(player: result.player);
      return;
    }

    AudioManager.instance.play(GameSound.footstep);
    var next = current.copyWith(player: result.player);
    if (_ref.read(checkWinUsecaseProvider)(next)) {
      _ticker?.cancel();
      AudioManager.instance.play(GameSound.win);
      state = next; // commit the final move first
      _finalizeWin(next);
      return;
    }
    state = next;
  }

  Future<void> _finalizeWin(GameSession session) async {
    final isNew = await _ref
        .read(saveScoreUsecaseProvider)(session.difficulty, session.totalTime);
    if (isNew) {
      _ref.read(scoreRefreshProvider.notifier).state++;
    }
    // Only emit the won status now so the UI navigates with the flag set.
    state = session.copyWith(status: GameStatus.won, wasNewRecord: isNew);
  }

  void togglePause() {
    final current = state;
    if (current == null || current.status == GameStatus.won) return;
    AudioManager.instance.play(GameSound.pauseToggle);
    if (current.status == GameStatus.playing) {
      state = current.copyWith(status: GameStatus.paused);
    } else {
      state = current.copyWith(status: GameStatus.playing);
    }
  }

  void toggleReveal() {
    final current = state;
    if (current == null || current.status != GameStatus.playing) return;
    final updated = _ref.read(revealMapUsecaseProvider)(current);
    if (updated.isMapRevealed && !current.isMapRevealed) {
      AudioManager.instance.play(GameSound.penalty);
    }
    state = updated;
  }

  void quit() {
    _ticker?.cancel();
    state = null;
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameSession?>(
    (ref) => GameNotifier(ref));
