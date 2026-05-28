import 'difficulty.dart';
import 'maze.dart';
import 'player.dart';

enum GameStatus { playing, paused, won }

/// Snapshot of a single play session. Immutable — the notifier replaces it
/// each tick with copyWith.
class GameSession {
  const GameSession({
    required this.maze,
    required this.player,
    required this.difficulty,
    required this.elapsedTime,
    required this.penaltyTime,
    required this.isMapRevealed,
    required this.mapRevealCount,
    required this.status,
    this.wasNewRecord = false,
  });

  final Maze maze;
  final Player player;
  final Difficulty difficulty;
  final Duration elapsedTime;
  final Duration penaltyTime;
  final bool isMapRevealed;
  final int mapRevealCount;
  final GameStatus status;

  /// True iff the player just set a new best time. Set when status transitions
  /// to [GameStatus.won]. Used by the win screen to decide which banner to show.
  final bool wasNewRecord;

  Duration get totalTime => elapsedTime + penaltyTime;

  bool get isPaused => status == GameStatus.paused;
  bool get isWon => status == GameStatus.won;
  bool get isPlaying => status == GameStatus.playing;

  GameSession copyWith({
    Maze? maze,
    Player? player,
    Difficulty? difficulty,
    Duration? elapsedTime,
    Duration? penaltyTime,
    bool? isMapRevealed,
    int? mapRevealCount,
    GameStatus? status,
    bool? wasNewRecord,
  }) =>
      GameSession(
        maze: maze ?? this.maze,
        player: player ?? this.player,
        difficulty: difficulty ?? this.difficulty,
        elapsedTime: elapsedTime ?? this.elapsedTime,
        penaltyTime: penaltyTime ?? this.penaltyTime,
        isMapRevealed: isMapRevealed ?? this.isMapRevealed,
        mapRevealCount: mapRevealCount ?? this.mapRevealCount,
        status: status ?? this.status,
        wasNewRecord: wasNewRecord ?? this.wasNewRecord,
      );
}
