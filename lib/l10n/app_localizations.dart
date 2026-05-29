import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// App title shown on home screen and in the OS task switcher
  ///
  /// In en, this message translates to:
  /// **'Home to Cisbox'**
  String get appTitle;

  /// Subtitle on the home screen below the app title
  ///
  /// In en, this message translates to:
  /// **'Find your way home to the office'**
  String get tagline;

  /// Easy difficulty label
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty label
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Hard difficulty label
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Generic play button
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// Pause button / overlay title
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// Resume button on pause overlay
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// Quit button on pause overlay
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quit;

  /// Win screen — start a new run
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Win screen — return to home
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get backToMenu;

  /// Win screen — main victory message
  ///
  /// In en, this message translates to:
  /// **'🎉 You made it to Cisbox!'**
  String get youWon;

  /// Win screen — shown when player beat their best time
  ///
  /// In en, this message translates to:
  /// **'🏆 New Record!'**
  String get newRecord;

  /// Label preceding the best time, e.g. 'Best: 01:23'
  ///
  /// In en, this message translates to:
  /// **'Best'**
  String get bestTime;

  /// Shown in place of best time when player has never finished this difficulty
  ///
  /// In en, this message translates to:
  /// **'None yet'**
  String get noRecord;

  /// Win screen label above the run's time
  ///
  /// In en, this message translates to:
  /// **'Your Time'**
  String get yourTime;

  /// Toast shown when player turns map reveal on
  ///
  /// In en, this message translates to:
  /// **'⏰ +30 seconds'**
  String get revealMapPenalty;

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Sound master toggle label
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// Section header for control-scheme picker
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get controlScheme;

  /// Control scheme: both enabled
  ///
  /// In en, this message translates to:
  /// **'D-pad + Swipe'**
  String get dpadAndSwipe;

  /// Control scheme: only the on-screen arrow pad
  ///
  /// In en, this message translates to:
  /// **'D-pad only'**
  String get dpadOnly;

  /// Control scheme: only swipe gestures
  ///
  /// In en, this message translates to:
  /// **'Swipe only'**
  String get swipeOnly;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
