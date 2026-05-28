/// Difficulty levels for the maze.
enum Difficulty { easy, medium, hard }

extension DifficultyX on Difficulty {
  /// Grid side (square mazes).
  int get size {
    switch (this) {
      case Difficulty.easy:
        return 10;
      case Difficulty.medium:
        return 15;
      case Difficulty.hard:
        return 20;
    }
  }

  /// Fog-of-war visibility radius in cells.
  double get visibilityRadius {
    switch (this) {
      case Difficulty.easy:
        return 3.0;
      case Difficulty.medium:
        return 2.0;
      case Difficulty.hard:
        return 1.5;
    }
  }

  String get storageKey {
    switch (this) {
      case Difficulty.easy:
        return 'easy';
      case Difficulty.medium:
        return 'medium';
      case Difficulty.hard:
        return 'hard';
    }
  }
}
