import '../entities/difficulty.dart';

abstract class ScoreRepository {
  /// Returns null if the player has never finished this difficulty.
  Future<Duration?> getBestTime(Difficulty difficulty);

  /// Persists [time] if it beats the existing best (or none exists).
  /// Returns true when a new record was written.
  Future<bool> saveIfBest(Difficulty difficulty, Duration time);
}
