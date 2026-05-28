import 'dart:developer' as developer;

import 'package:audioplayers/audioplayers.dart';

import '../../../core/utils/audio_manager.dart';

/// Plays game SFX.
///
/// We don't ship audio files in this scaffold, so the implementation logs the
/// requested sound. To enable real audio:
///   1. Drop .mp3 / .wav files into assets/sounds/
///   2. Enable the `assets:` entry for `assets/sounds/` in pubspec.yaml
///   3. Map sounds in [_assetForSound] and uncomment the play call.
class AudioPlayersDatasource {
  final AudioPlayer _player = AudioPlayer();

  String? _assetForSound(GameSound sound) {
    // TODO: provide real assets, e.g.:
    //   case GameSound.footstep: return 'sounds/footstep.wav';
    switch (sound) {
      case GameSound.footstep:
      case GameSound.wallBump:
      case GameSound.win:
      case GameSound.pauseToggle:
      case GameSound.penalty:
        return null;
    }
  }

  Future<void> play(GameSound sound) async {
    final asset = _assetForSound(sound);
    if (asset == null) {
      developer.log('SFX (no asset): $sound', name: 'audio');
      return;
    }
    try {
      await _player.stop();
      await _player.play(AssetSource(asset));
    } catch (e) {
      developer.log('Failed to play $sound: $e', name: 'audio');
    }
  }

  Future<void> dispose() => _player.dispose();
}
