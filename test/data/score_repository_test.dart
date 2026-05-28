import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:home_to_cisbox/data/datasources/local/hive_score_datasource.dart';
import 'package:home_to_cisbox/data/models/score_model.dart';
import 'package:home_to_cisbox/data/repositories/score_repository_impl.dart';
import 'package:home_to_cisbox/domain/entities/difficulty.dart';

void main() {
  late Box<ScoreModel> box;
  late HiveScoreDatasource ds;
  late ScoreRepositoryImpl repo;

  setUpAll(() {
    // Hive.init with a temp directory works fine without path_provider in tests.
    Hive.init('./.dart_tool/test_hive_${DateTime.now().millisecondsSinceEpoch}');
    Hive.registerAdapter(ScoreModelAdapter());
  });

  setUp(() async {
    box = await Hive.openBox<ScoreModel>(
        'scores_test_${DateTime.now().microsecondsSinceEpoch}');
    ds = HiveScoreDatasource(box);
    repo = ScoreRepositoryImpl(ds);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  group('ScoreRepositoryImpl', () {
    test('returns null when no record exists', () async {
      final result = await repo.getBestTime(Difficulty.easy);
      expect(result, isNull);
    });

    test('saves the first time', () async {
      final saved =
          await repo.saveIfBest(Difficulty.easy, const Duration(seconds: 30));
      expect(saved, isTrue);
      final best = await repo.getBestTime(Difficulty.easy);
      expect(best, const Duration(seconds: 30));
    });

    test('overwrites only with a better (smaller) time', () async {
      await repo.saveIfBest(Difficulty.easy, const Duration(seconds: 30));
      final tryWorse =
          await repo.saveIfBest(Difficulty.easy, const Duration(seconds: 45));
      expect(tryWorse, isFalse);
      final stillBest = await repo.getBestTime(Difficulty.easy);
      expect(stillBest, const Duration(seconds: 30));

      final tryBetter =
          await repo.saveIfBest(Difficulty.easy, const Duration(seconds: 20));
      expect(tryBetter, isTrue);
      expect(await repo.getBestTime(Difficulty.easy),
          const Duration(seconds: 20));
    });

    test('tracks different difficulties independently', () async {
      await repo.saveIfBest(Difficulty.easy, const Duration(seconds: 10));
      await repo.saveIfBest(Difficulty.hard, const Duration(seconds: 100));
      expect(await repo.getBestTime(Difficulty.easy),
          const Duration(seconds: 10));
      expect(await repo.getBestTime(Difficulty.hard),
          const Duration(seconds: 100));
      expect(await repo.getBestTime(Difficulty.medium), isNull);
    });
  });
}
