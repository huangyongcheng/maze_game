import '../../core/utils/audio_manager.dart';

abstract class AudioRepository {
  Future<void> play(GameSound sound);
  Future<void> dispose();
}
