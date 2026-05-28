import 'cell.dart';
import 'direction.dart';
import 'position.dart';

/// A perfect maze: a width × height grid with exactly one path between any
/// two cells.
class Maze {
  Maze({
    required this.width,
    required this.height,
    required this.cells,
    required this.start,
    required this.end,
  });

  final int width;
  final int height;
  final List<List<Cell>> cells; // cells[y][x]
  final Position start;
  final Position end;

  Cell cellAt(Position p) => cells[p.y][p.x];

  bool isInside(Position p) =>
      p.x >= 0 && p.x < width && p.y >= 0 && p.y < height;

  /// Returns true if a wall blocks movement from [p] in [direction].
  bool hasWall(Position p, Direction direction) =>
      cellAt(p).wallInDirection(direction);
}
