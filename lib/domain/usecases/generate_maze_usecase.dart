import '../entities/difficulty.dart';
import '../entities/maze.dart';
import '../repositories/maze_repository.dart';

class GenerateMazeUsecase {
  const GenerateMazeUsecase(this._repo);
  final MazeRepository _repo;

  Maze call(Difficulty difficulty) => _repo.generate(difficulty);
}
