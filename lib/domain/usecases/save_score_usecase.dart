import '../entities/difficulty.dart';
import '../repositories/score_repository.dart';

class SaveScoreUsecase {
  const SaveScoreUsecase(this._repo);
  final ScoreRepository _repo;

  /// Returns true if a new record was written.
  Future<bool> call(Difficulty difficulty, Duration time) =>
      _repo.saveIfBest(difficulty, time);
}
