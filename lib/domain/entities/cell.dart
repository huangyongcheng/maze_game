import 'direction.dart';

/// A single maze cell.
///
/// A cell tracks which of its 4 walls are still standing. The generator
/// removes walls between visited cells; the renderer reads them to draw.
class Cell {
  Cell({
    this.northWall = true,
    this.eastWall = true,
    this.southWall = true,
    this.westWall = true,
    this.visited = false,
  });

  bool northWall;
  bool eastWall;
  bool southWall;
  bool westWall;
  bool visited;

  bool wallInDirection(Direction direction) {
    switch (direction) {
      case Direction.north:
        return northWall;
      case Direction.east:
        return eastWall;
      case Direction.south:
        return southWall;
      case Direction.west:
        return westWall;
    }
  }

  void removeWall(Direction direction) {
    switch (direction) {
      case Direction.north:
        northWall = false;
        break;
      case Direction.east:
        eastWall = false;
        break;
      case Direction.south:
        southWall = false;
        break;
      case Direction.west:
        westWall = false;
        break;
    }
  }
}
