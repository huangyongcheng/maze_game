import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/audio_manager.dart';

enum ControlScheme { dpadAndSwipe, dpadOnly, swipeOnly }

class SettingsState {
  const SettingsState({
    this.soundOn = true,
    this.controlScheme = ControlScheme.dpadAndSwipe,
  });

  final bool soundOn;
  final ControlScheme controlScheme;

  bool get dpadEnabled =>
      controlScheme == ControlScheme.dpadAndSwipe ||
      controlScheme == ControlScheme.dpadOnly;

  bool get swipeEnabled =>
      controlScheme == ControlScheme.dpadAndSwipe ||
      controlScheme == ControlScheme.swipeOnly;

  SettingsState copyWith({bool? soundOn, ControlScheme? controlScheme}) =>
      SettingsState(
        soundOn: soundOn ?? this.soundOn,
        controlScheme: controlScheme ?? this.controlScheme,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    AudioManager.instance.setMuted(!state.soundOn);
  }

  void setSoundOn(bool on) {
    state = state.copyWith(soundOn: on);
    AudioManager.instance.setMuted(!on);
  }

  void setControlScheme(ControlScheme scheme) {
    state = state.copyWith(controlScheme: scheme);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>(
        (ref) => SettingsNotifier());
