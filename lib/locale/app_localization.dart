import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kifcab/constant.dart';
import '../l10n/messages_all.dart';

//flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_* lib/locale/app_localization.dart

class AppLocalization {
  static Future<AppLocalization> load(Locale locale) {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalization();
    });
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static String _loadStaticMessage(
      String key, String locale, Map<String, dynamic> args) {
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
    return Intl.message("Patientez quelques instants...",
        name: 'waitAfewMoments');
  }

  String get login {
    return Intl.message("Se connecter", name: 'login');
  }

  String get createAnAccount {
    return Intl.message("Créer un compte", name: 'createAnAccount');
  }

  String get welcomeMessage {
    return Intl.message("Commande simple et rapide de véhicules ...",
        name: 'welcomeMessage');
  }

  String get next {
    return Intl.message("Suivant", name: 'next');
  }

  String get noAccount {
    return Intl.message("Pas de compte?", name: 'noAccount');
  }

  changeLanguage(language) => Intl.message("Changer langue($language)",
      name: 'changeLanguage', args: [language]);

  String get hintPhoneLogin {
    return Intl.message("Téléphone", name: 'hintPhoneLogin');
  }

  String get forgetcode {
    return Intl.message("Code oublier ?", name: 'forgetcode');
  }

  String get succeswelcome {
    return Intl.message("Nous sommes Heureux de vous revoir",
        name: 'succeswelcome');
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

  String get activationcode {
    return Intl.message("Code d'activation", name: 'activationcode');
  }

  String get course {
    return Intl.message("Course", name: 'course');
  }

  String get location {
    return Intl.message("Location", name: 'location');
  }

  String get chooseOfCommandType {
    return Intl.message("Choix du type de commande",
        name: 'chooseOfCommandType');
  }

  String get home {
    return Intl.message("Accueil", name: 'home');
  }

  String get checkphonenumber {
    return Intl.message("Numéro de téléphone incorrect",
        name: 'checkphonenumber');
  }

  String get checkcodenumber {
    return Intl.message("Verifier votre code", name: 'checkcodenumber');
  }

  String get checkmessagech {
    return Intl.message("Veuillez renseigner le message",
        name: 'checkmessagech');
  }

  String get sendacticode {
    return Intl.message(
        "Nous avons envoyer votre nouveau code d'activation au ",
        name: 'sendacticode');
  }

  String get sendnewcode {
    return Intl.message("Envoi du code au ", name: 'sendacticode');
  }

  String get incorectphon {
    return Intl.message("Numéro incorect ?", name: 'sendacticode');
  }

  String get wait {
    return Intl.message("Veuillez Patienter", name: 'wait');
  }

  String get history {
    return Intl.message("Historiques", name: 'history');
  }

  String get validEmail {
    return Intl.message("Vérifier votre Email", name: 'validEmail');
  }

  String get validname {
    return Intl.message("Vérifier votre Nom", name: 'validname');
  }

  String get validville {
    return Intl.message("Vérifier votre Ville", name: 'validville');
  }

  String get errorcomptenotexist {
    return Intl.message(
        "Désolé mais ce numéro ne correspond a aucun utilisateur",
        name: 'history');
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
    return Intl.message("Politiques de confidentialités",
        name: 'privacyPolicies');
  }

  copyrightMessage(year) => Intl.message("Copyright $year.Tous droits reservés",
      name: 'copyrightMessage', args: [year]);

  String get needASecureCar {
    return Intl.message("Besoin d'une voiture sécurisée?",
        name: 'needASecureCar');
  }

  String get takeADeposit {
    return Intl.message("Prenez un dépot", name: 'takeADeposit');
  }

  String get previous {
    return Intl.message("Précédent", name: 'previous');
  }

  String get notinternet {
    return Intl.message("Vérifier votre connexion internet",
        name: 'notinternet');
  }

  String get startingPoint {
    return Intl.message("Point de départ", name: 'startingPoint');
  }

  String get erroricorectcode {
    return Intl.message("Désolé ce code est incorect",
        name: 'erroricorectcode');
  }

  String get errornotallow {
    return Intl.message("Vous n'etes pas autorité a utiliser c'est application",
        name: 'errornotallow');
  }

  String get arrivalPoint {
    return Intl.message("Point d'arrivée", name: 'arrivalPoint');
  }

  String get required {
    return Intl.message("*Obligatoire", name: 'required');
  }

  String get enterTheStartingPoint {
    return Intl.message("Entrer le point de départ",
        name: 'enterTheStartingPoint');
  }

  String get valenterTheStartingPoint {
    return Intl.message("Veuillez renseigner le point de départ",
        name: 'enterTheStartingPoint');
  }

  String get enterTheArrivalPoint {
    return Intl.message("Entrer le point d'arrivée",
        name: 'enterTheArrivalPoint');
  }

  String get valenterTheArrivalPoint {
    return Intl.message("Veuillez renseigner le point d'arrivée",
        name: 'enterTheArrivalPoint');
  }

  String get messageToSendToTheDriver {
    return Intl.message("Message à transmettre au chauffeur",
        name: 'messageToSendToTheDriver');
  }

  String get ranges {
    return Intl.message("Gammes", name: 'ranges');
  }

  String get payment {
    return Intl.message("Paiement", name: 'payment');
  }

  String get needToHelp {
    return Intl.message("Besoin d'aide", name: 'needToHelp');
  }

  String get contactUs {
    return Intl.message("Nous contacter", name: 'contactUs');
  }

  String get contact {
    return Intl.message("Contact", name: 'contact');
  }

  String get contactUsMessage {
    return Intl.message(
        "Pour toutes question concernant les services Kifcab, bien vouloir contacter notre service client au :",
        name: 'contactUsMessage');
  }

  helpTel(phone) =>
      Intl.message("Tel -  $phone", name: 'helpTel', args: [phone]);
  helpWhatsapp(phone) =>
      Intl.message("Whatsapp -  $phone", name: 'helpWhatsapp', args: [phone]);

  String get aboutUs {
    return Intl.message("A propos de", name: 'aboutUs');
  }

  String get aboutUsSubtitle {
    return Intl.message("Application de commande de voiture ...",
        name: 'aboutUsSubtitle');
  }

  String get whoAreUs {
    return Intl.message("Qui sommes-nous", name: 'whoAreUs');
  }

  String get whoAreUsMessage {
    return Intl.message(
        "Kifcab est une sarl de droit Camerounais crée en 2017 situé à Bonapriso Douala",
        name: 'whoAreUsMessage');
  }

  String get moreAlso {
    return Intl.message("Plus encore...", name: 'moreAlso');
  }

  String get moreAlsoMessage1 {
    return Intl.message(
        "Kifcab est une application mobile permettant de mettre en relation des clients voulant emprunter un taxi sécurisé avec des professionnels du transport répertoriés dans sa base de données pour une course, dépôt ou location.",
        name: 'moreAlsoMessage1');
  }

  String get moreAlsoMessage2 {
    return Intl.message(
        "Ces professionnels de transport font l’objet d’une vérification rigoureuse de leurs papiers administratifs, de la conformité de leurs véhicules ainsi que l’identité et la moralité des chauffeurs. Tous les véhicules Kifcab sont géolocalisés et contrôlés en permanence pour offrir un maximum de sécurité à nos clients.",
        name: 'moreAlsoMessage2');
  }

  String get cgi {
    return Intl.message("Cgi", name: 'cgi');
  }

  String get profil {
    return Intl.message("Profil", name: 'profil');
  }

  String get myAccount {
    return Intl.message("Mon compte", name: 'myAccount');
  }

  String get becomeDriver {
    return Intl.message("Devenir chauffeur", name: 'becomeDriver');
  }

  String get logout {
    return Intl.message("Deconnexion", name: 'logout');
  }

  String get processToFollow {
    return Intl.message("Procedure à Suivre", name: 'processToFollow');
  }

  String get processToFollowMessage {
    return Intl.message(
        "Signer accord de géolocalisation du véhicule \n Papiers administratifs du véhicule en règle (copies et originaux) \n CNI propriétaire et chauffeurs \n Contactez les numéros",
        name: 'processToFollowMessage');
  }

  String get accountInformations {
    return Intl.message("Informations du compte", name: 'accountInformations');
  }

  yourSex(code) =>
      Intl.message("Votre Sexe($code)", name: 'yourSex', args: [code]);

  String get enterYourLastName {
    return Intl.message("Entrer votre nom", name: 'enterYourLastName');
  }

  String get enterYourFirstName {
    return Intl.message("Entrer votre prenom", name: 'enterYourFirstName');
  }

  String get enterYourLocalization {
    return Intl.message("Entrer votre localisation",
        name: 'enterYourLocalization');
  }

  String get enterYourEmail {
    return Intl.message("Entrer votre email", name: 'enterYourEmail');
  }

  String get enterYourBirthdate {
    return Intl.message("Entrer votre date de naissance",
        name: 'enterYourBirthdate');
  }

  String get tellUsSomethingAboutYou {
    return Intl.message("Dîtes-nous quelque chose sur vous",
        name: 'tellUsSomethingAboutYou');
  }

  String get male {
    return Intl.message("Masculin(M)", name: 'male');
  }

  String get female {
    return Intl.message("Feminin(F)", name: 'female');
  }

  displayIn(language) => Intl.message("Display in, $language!",
      name: 'displayIn', args: [language]);
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  final Locale overriddenLocale;

  const AppLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) =>
      SUPPORTED_LANGUAGES.contains(locale.languageCode);

  @override
  Future<AppLocalization> load(Locale locale) => AppLocalization.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalization> old) => false;
}

//see here how to format arb file
//https://www.raywenderlich.com/10794904-internationalizing-and-localizing-your-flutter-app
//command:  flutter pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/l10n/intl_* lib/locale/app_localization.dart
