import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kifcab/constant.dart';
import '../l10n/messages_all.dart';

//flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_* lib/locale/app_localization.dart

class AppLocalization {
  static Future<AppLocalization> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalization();
    });
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static String _loadStaticMessage(String key, String locale, Map<String, dynamic> args) {
    if (locale == 'en') {
      switch (key) {
        case "reset":
          return Intl.message('Reset', locale: locale);
      }
    } else if (locale == "fr") {
      switch (key) {
        case "reset":
          return Intl.message('Annuler', locale: locale);
      }
    }
  }

  String get waitAfewMoments {
    return Intl.message("Patientez quelques instants...", name: 'waitAfewMoments');
  }

  displayIn(language) => Intl.message("Display in, $language!", name: 'displayIn', args: [language]);
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  final Locale overriddenLocale;

  const AppLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => SUPPORTED_LANGUAGES.contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}

//see here how to format arb file
//https://www.raywenderlich.com/10794904-internationalizing-and-localizing-your-flutter-app
//command:  flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_* lib/locale/app_localization.dart
