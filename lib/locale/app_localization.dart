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
  String get hintName {
    return Intl.message("Nom[Obligatoire]", name: 'hintName');
  }
  String get hintEmail {
    return Intl.message("Email[Obligatoire]", name: 'hintEmail');
  }
  String get hintPhone {
    return Intl.message("Téléphone[Obligatoire]", name: 'hintPhone');
  }
  String get hintLocalization {
    return Intl.message("Localisation", name: 'hintLocalization');
  }
  String get save {
    return Intl.message("Enregistrer", name: 'save');
  }

  String get alreadyHaveAccount {
    return Intl.message("Déjà un compte?", name: 'alreadyHaveAccount');
  }
  String get waitAfewMoments {
    return Intl.message("Patientez quelques instants...", name: 'waitAfewMoments');
  }

  String get login {
    return Intl.message("Se connecter", name: 'login');
  }
  String get createAnAccount {
    return Intl.message("Créer un compte", name: 'createAnAccount');
  }

  String get welcomeMessage {
    return Intl.message("Commande simple et rapide de véhicules ...", name: 'welcomeMessage');
  }

  String get next {
    return Intl.message("Suivant", name: 'next');
  }

  String get noAccount {
    return Intl.message("Pas de compte?", name: 'noAccount');
  }
  changeLanguage(language) => Intl.message("Changer langue($language)", name: 'changeLanguage', args: [language]);

  String get hintPhoneLogin {
    return Intl.message("Téléphone", name: 'hintPhoneLogin');
  }

  String get enterYourPhone {
    return Intl.message("Entrer votre Téléphone", name: 'enterYourPhone');
  }
  String get examplePhoneNumber {
    return Intl.message("Example: 666999777", name: 'examplePhoneNumber');
  }

  String get deposit {
    return Intl.message("Dépot", name: 'deposit');
  }

  String get course {
    return Intl.message("Course", name: 'course');
  }

  String get location {
    return Intl.message("Location", name: 'location');
  }

  String get chooseOfCommandType {
    return Intl.message("Choix du type de commande", name: 'chooseOfCommandType');
  }

  String get home {
    return Intl.message("Accueil", name: 'home');
  }

  String get history {
    return Intl.message("Historiques", name: 'history');
  }
  String get settings {
    return Intl.message("Paramètres", name: 'settings');
  }
  String get help {
    return Intl.message("Aide", name: 'help');
  }
  String get aboutApp {
    return Intl.message("A propos de Kifcab", name: 'aboutApp');
  }
  String get privacyPolicies {
    return Intl.message("Politiques de confidentialités", name: 'privacyPolicies');
  }
  copyrightMessage(year) => Intl.message("Copyright $year.Tous droits reservés", name: 'copyrightMessage', args: [year]);



  String get needASecureCar {
    return Intl.message("Besoin d'une voiture sécurisée?", name: 'needASecureCar');
  }
  String get takeADeposit {
    return Intl.message("Prenez un dépot", name: 'takeADeposit');
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
