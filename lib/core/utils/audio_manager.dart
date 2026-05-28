import 'dart:developer' as developer;

/// Sound events emitted by the game.
enum GameSound {
  footstep,
  wallBump,
  win,
  pauseToggle,
  penalty,
}

/// Singleton wrapper around the audio repository.
///
/// Real audio playback is delegated to [AudioRepository]. This singleton
/// adds a master-mute flag so any layer can call [play] without caring
/// about settings.
///
/// TODO: Drop real audio files into assets/sounds/ and wire them through
/// AudiopayersDatasource.playAsset. Until then, sound events are logged.
class AudioManager {
  AudioManager._();
  static final AudioManager instance = AudioManager._();

  bool _muted = false;
  void Function(GameSound sound)? _handler;

  void setMuted(bool muted) {
    _muted = muted;
  }

  bool get isMuted => _muted;

  /// Wire up the concrete player. Called once from main.dart after the
  /// repository is constructed.
  void bind(void Function(GameSound sound) handler) {
    _handler = handler;
  }

  void play(GameSound sound) {
    if (_muted) return;
    final handler = _handler;
    if (handler == null) {
      developer.log('AudioManager not bound yet — would play $sound',
          name: 'audio');
      return;
    }
    handler(sound);
  }
}
