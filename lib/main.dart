import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/utils/audio_manager.dart';
import 'data/datasources/audio/audioplayers_datasource.dart';
import 'data/datasources/local/hive_score_datasource.dart';
import 'data/models/score_model.dart';
import 'data/repositories/audio_repository_impl.dart';
import 'presentation/providers/score_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive setup.
  await Hive.initFlutter();
  Hive.registerAdapter(ScoreModelAdapter());
  final scoreBox =
      await Hive.openBox<ScoreModel>(HiveScoreDatasource.boxName);

  // Audio setup.
  final audioRepo = AudioRepositoryImpl(AudioPlayersDatasource());
  AudioManager.instance.bind((sound) => audioRepo.play(sound));

  runApp(
    ProviderScope(
      overrides: [
        scoreBoxProvider.overrideWithValue(scoreBox),
      ],
      child: const HomeToCisboxApp(),
    ),
  );
}
