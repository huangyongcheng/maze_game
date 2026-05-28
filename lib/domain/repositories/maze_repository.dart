import '../entities/difficulty.dart';
import '../entities/maze.dart';

abstract class MazeRepository {
  /// Generate a fresh perfect maze of the requested difficulty.
  Maze generate(Difficulty difficulty);
}
