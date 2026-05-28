import 'dart:math';

import '../../domain/entities/cell.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/direction.dart';
import '../../domain/entities/maze.dart';
import '../../domain/entities/position.dart';
import '../../domain/repositories/maze_repository.dart';

/// Generates perfect mazes using iterative recursive backtracking.
///
/// A "perfect" maze has exactly one path between any two cells (no loops,
/// no isolated regions). The algorithm:
///
///   1. Start with every cell walled in on all four sides.
///   2. Pick a starting cell (here: 0,0), mark visited, push onto a stack.
///   3. While the stack is non-empty:
///       a. Look at the top cell. If it has any unvisited neighbour,
///          pick one at random, knock down the wall between them, mark
///          the neighbour visited and push it onto the stack.
///       b. Otherwise pop.
///   4. Start = (0,0), End = (width-1, height-1).
class MazeRepositoryImpl implements MazeRepository {
  MazeRepositoryImpl({Random? random}) : _random = random ?? Random();

  final Random _random;

  @override
  Maze generate(Difficulty difficulty) {
    final size = difficulty.size;
    return _generate(size, size);
  }

  Maze _generate(int width, int height) {
    final cells = List<List<Cell>>.generate(
      height,
      (_) => List<Cell>.generate(width, (_) => Cell()),
    );

    final stack = <Position>[];
    const start = Position(0, 0);
    cells[start.y][start.x].visited = true;
    stack.add(start);

    while (stack.isNotEmpty) {
      final current = stack.last;
      final neighbours = _unvisitedNeighbours(current, cells, width, height);
      if (neighbours.isEmpty) {
        stack.removeLast();
        continue;
      }
      final pick = neighbours[_random.nextInt(neighbours.length)];
      final neighbourPos = current.translate(pick);
      // Knock down the wall on both sides.
      cells[current.y][current.x].removeWall(pick);
      cells[neighbourPos.y][neighbourPos.x].removeWall(pick.opposite);
      cells[neighbourPos.y][neighbourPos.x].visited = true;
      stack.add(neighbourPos);
    }

    // Clear the `visited` flags so the renderer can reuse them for the
    // breadcrumb trail or any future logic.
    for (final row in cells) {
      for (final c in row) {
        c.visited = false;
      }
    }

    return Maze(
      width: width,
      height: height,
      cells: cells,
      start: start,
      end: Position(width - 1, height - 1),
    );
  }

  List<Direction> _unvisitedNeighbours(
    Position p,
    List<List<Cell>> cells,
    int width,
    int height,
  ) {
    final result = <Direction>[];
    for (final dir in Direction.values) {
      final n = p.translate(dir);
      if (n.x < 0 || n.x >= width || n.y < 0 || n.y >= height) continue;
      if (cells[n.y][n.x].visited) continue;
      result.add(dir);
    }
    return result;
  }
}
