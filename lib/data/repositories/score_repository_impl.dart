import '../../domain/entities/difficulty.dart';
import '../../domain/repositories/score_repository.dart';
import '../datasources/local/hive_score_datasource.dart';
import '../models/score_model.dart';

class ScoreRepositoryImpl implements ScoreRepository {
  ScoreRepositoryImpl(this._ds);
  final HiveScoreDatasource _ds;

  @override
  Future<Duration?> getBestTime(Difficulty difficulty) async {
    final model = _ds.read(difficulty.storageKey);
    return model?.bestTime;
  }

  @override
  Future<bool> saveIfBest(Difficulty difficulty, Duration time) async {
    final existing = _ds.read(difficulty.storageKey);
    if (existing != null && existing.bestTimeMillis <= time.inMilliseconds) {
      return false;
    }
    await _ds.write(ScoreModel(
      difficulty: difficulty.storageKey,
      bestTimeMillis: time.inMilliseconds,
      achievedAt: DateTime.now(),
    ));
    return true;
  }
}
