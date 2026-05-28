import 'package:hive/hive.dart';

part 'score_model.g.dart';

/// Persistent record of a best time for a given difficulty.
@HiveType(typeId: 0)
class ScoreModel extends HiveObject {
  ScoreModel({
    required this.difficulty,
    required this.bestTimeMillis,
    required this.achievedAt,
  });

  @HiveField(0)
  String difficulty;

  @HiveField(1)
  int bestTimeMillis;

  @HiveField(2)
  DateTime achievedAt;

  Duration get bestTime => Duration(milliseconds: bestTimeMillis);
}
