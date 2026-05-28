import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/local/hive_score_datasource.dart';
import '../../data/models/score_model.dart';
import '../../data/repositories/score_repository_impl.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/repositories/score_repository.dart';
import '../../domain/usecases/get_best_time_usecase.dart';
import '../../domain/usecases/save_score_usecase.dart';
import 'package:hive/hive.dart';

/// Provides the open Hive box. Must be overridden in main() once Hive is
/// initialized.
final scoreBoxProvider = Provider<Box<ScoreModel>>((ref) {
  throw UnimplementedError(
      'scoreBoxProvider must be overridden with the open Hive box');
});

final scoreDatasourceProvider = Provider<HiveScoreDatasource>(
    (ref) => HiveScoreDatasource(ref.watch(scoreBoxProvider)));

final scoreRepositoryProvider = Provider<ScoreRepository>(
    (ref) => ScoreRepositoryImpl(ref.watch(scoreDatasourceProvider)));

final saveScoreUsecaseProvider = Provider<SaveScoreUsecase>(
    (ref) => SaveScoreUsecase(ref.watch(scoreRepositoryProvider)));

final getBestTimeUsecaseProvider = Provider<GetBestTimeUsecase>(
    (ref) => GetBestTimeUsecase(ref.watch(scoreRepositoryProvider)));

/// Bumps every time we save a new record, so best-time futures re-fetch.
final scoreRefreshProvider = StateProvider<int>((ref) => 0);

final bestTimeProvider =
    FutureProvider.family<Duration?, Difficulty>((ref, difficulty) async {
  ref.watch(scoreRefreshProvider);
  return ref.watch(getBestTimeUsecaseProvider)(difficulty);
});
