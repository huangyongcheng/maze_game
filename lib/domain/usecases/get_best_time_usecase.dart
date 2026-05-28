import '../entities/difficulty.dart';
import '../repositories/score_repository.dart';

class GetBestTimeUsecase {
  const GetBestTimeUsecase(this._repo);
  final ScoreRepository _repo;

  Future<Duration?> call(Difficulty difficulty) => _repo.getBestTime(difficulty);
}
