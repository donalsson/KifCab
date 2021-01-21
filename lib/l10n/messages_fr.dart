// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static m0(name) => "Je choisis la langue: ${name}";

  static m1(name) => "Je choisis le thème: ${name}";

  static m2(name) => "J\'annule et je continue avec la langue: ${name}";

  static m3(name) => "J\'annule et je continue avec le thème: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{"chooseThisLanguage": MessageLookupByLibrary.simpleMessage("Choisir cette langue"), "chooseThisTheme": MessageLookupByLibrary.simpleMessage("Choisir ce thème"), "confirmLanguageMessage": m0, "confirmQuitApplication": MessageLookupByLibrary.simpleMessage("Voulez-vous vraiment quitter Mira ?"), "confirmThemeMessage": m1, "no": MessageLookupByLibrary.simpleMessage("Non"), "quitApplication": MessageLookupByLibrary.simpleMessage("Quitter l\'application"), "reset": MessageLookupByLibrary.simpleMessage("Annuler"), "resetLanguageMessage": m2, "resetThemeMessage": m3, "saySomething": MessageLookupByLibrary.simpleMessage("Dîtes quelque chose..."), "select": MessageLookupByLibrary.simpleMessage("Sélectionner"), "themeProposal": MessageLookupByLibrary.simpleMessage("Je vous propose les thèmes ci-dessous"), "wichToChangeLanguage": MessageLookupByLibrary.simpleMessage("Mira, je souhaite changer de langue"), "wichToChangeTheme": MessageLookupByLibrary.simpleMessage("Mira, je souhaite changer de thème"), "yes": MessageLookupByLibrary.simpleMessage("Oui")};
}
