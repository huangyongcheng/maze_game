import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: Text(l10n.sound),
              value: settings.soundOn,
              onChanged: notifier.setSoundOn,
              activeThumbColor: AppColors.playerColor,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(l10n.controlScheme,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            RadioGroup<ControlScheme>(
              groupValue: settings.controlScheme,
              onChanged: (v) {
                if (v != null) notifier.setControlScheme(v);
              },
              child: Column(
                children: [
                  RadioListTile<ControlScheme>(
                    title: Text(l10n.dpadAndSwipe),
                    value: ControlScheme.dpadAndSwipe,
                  ),
                  RadioListTile<ControlScheme>(
                    title: Text(l10n.dpadOnly),
                    value: ControlScheme.dpadOnly,
                  ),
                  RadioListTile<ControlScheme>(
                    title: Text(l10n.swipeOnly),
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
