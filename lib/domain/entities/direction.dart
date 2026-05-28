/// Cardinal directions used for movement and wall removal.
enum Direction { north, east, south, west }

extension DirectionX on Direction {
  /// Delta in (dx, dy) — north decreases y, east increases x.
  ({int dx, int dy}) get delta {
    switch (this) {
      case Direction.north:
        return (dx: 0, dy: -1);
      case Direction.east:
        return (dx: 1, dy: 0);
      case Direction.south:
        return (dx: 0, dy: 1);
      case Direction.west:
        return (dx: -1, dy: 0);
    }
  }

  Direction get opposite {
    switch (this) {
      case Direction.north:
        return Direction.south;
      case Direction.east:
        return Direction.west;
      case Direction.south:
        return Direction.north;
      case Direction.west:
        return Direction.east;
    }
  }
}
