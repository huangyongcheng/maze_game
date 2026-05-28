import '../entities/direction.dart';
import '../entities/maze.dart';
import '../entities/player.dart';
import '../entities/position.dart';

/// Result of attempting a move.
class MoveResult {
  const MoveResult({required this.player, required this.movedThroughWall});
  final Player player;
  final bool movedThroughWall; // true if blocked by a wall (no position change)
}

class MovePlayerUsecase {
  const MovePlayerUsecase();

  MoveResult call({
    required Maze maze,
    required Player player,
    required Direction direction,
  }) {
    if (maze.hasWall(player.position, direction)) {
      return MoveResult(
        player: player.copyWith(facing: direction),
        movedThroughWall: true,
      );
    }
    final Position next = player.position.translate(direction);
    if (!maze.isInside(next)) {
      return MoveResult(
        player: player.copyWith(facing: direction),
        movedThroughWall: true,
      );
    }
    return MoveResult(
      player: player.copyWith(position: next, facing: direction),
      movedThroughWall: false,
    );
  }
}
