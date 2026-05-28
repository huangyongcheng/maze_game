import '../../core/utils/audio_manager.dart';
import '../../domain/repositories/audio_repository.dart';
import '../datasources/audio/audioplayers_datasource.dart';

class AudioRepositoryImpl implements AudioRepository {
  AudioRepositoryImpl(this._datasource);
  final AudioPlayersDatasource _datasource;

  @override
  Future<void> play(GameSound sound) => _datasource.play(sound);

  @override
  Future<void> dispose() => _datasource.dispose();
}
