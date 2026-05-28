import 'package:hive/hive.dart';

import '../../models/score_model.dart';

/// Thin wrapper over the Hive 'scores' box, keyed by difficulty string.
class HiveScoreDatasource {
  HiveScoreDatasource(this._box);

  static const String boxName = 'scores';

  final Box<ScoreModel> _box;

  ScoreModel? read(String difficultyKey) => _box.get(difficultyKey);

  Future<void> write(ScoreModel model) =>
      _box.put(model.difficulty, model);
}
