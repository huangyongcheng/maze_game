import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text(AppStrings.sound),
              value: settings.soundOn,
              onChanged: notifier.setSoundOn,
              activeThumbColor: AppColors.playerColor,
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(AppStrings.controlScheme,
                  style: TextStyle(fontWeight: FontWeight.w600)),
            ),
            RadioGroup<ControlScheme>(
              groupValue: settings.controlScheme,
              onChanged: (v) {
                if (v != null) notifier.setControlScheme(v);
              },
              child: const Column(
                children: [
                  RadioListTile<ControlScheme>(
                    title: Text(AppStrings.dpadAndSwipe),
                    value: ControlScheme.dpadAndSwipe,
                  ),
                  RadioListTile<ControlScheme>(
                    title: Text(AppStrings.dpadOnly),
                    value: ControlScheme.dpadOnly,
                  ),
                  RadioListTile<ControlScheme>(
                    title: Text(AppStrings.swipeOnly),
                    value: ControlScheme.swipeOnly,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
