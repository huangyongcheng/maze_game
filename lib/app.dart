import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/screens/splash_screen.dart';

class HomeToCisboxApp extends StatelessWidget {
  const HomeToCisboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // The OS task-switcher title needs a string up-front, but we still want
      // it to be localized. onGenerateTitle is called whenever the locale
      // changes and runs after the localizations delegate is ready.
      onGenerateTitle: (ctx) => AppLocalizations.of(ctx).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      // Force English regardless of system locale. To follow system locale
      // instead, remove this line — Flutter will pick the best match from
      // supportedLocales.
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashScreen(),
    );
  }
}
