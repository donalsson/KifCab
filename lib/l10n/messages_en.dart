// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static m0(name) => "I choose the language: ${name}";

  static m1(name) => "I choose the theme: ${name}";

  static m2(name) => "I cancel and continue with the language: ${name}";

  static m3(name) => "I cancel and continue with the theme: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function>{"chooseThisLanguage": MessageLookupByLibrary.simpleMessage("Choose this language"), "chooseThisTheme": MessageLookupByLibrary.simpleMessage("Choose this theme"), "confirmLanguageMessage": m0, "confirmQuitApplication": MessageLookupByLibrary.simpleMessage("Are you sure you want to leave Mira?"), "confirmThemeMessage": m1, "no": MessageLookupByLibrary.simpleMessage("No"), "quitApplication": MessageLookupByLibrary.simpleMessage("Exit the application"), "reset": MessageLookupByLibrary.simpleMessage("Reset"), "resetLanguageMessage": m2, "resetThemeMessage": m3, "saySomething": MessageLookupByLibrary.simpleMessage("Say something..."), "select": MessageLookupByLibrary.simpleMessage("Select"), "themeProposal": MessageLookupByLibrary.simpleMessage("I suggest the themes below"), "wichToChangeLanguage": MessageLookupByLibrary.simpleMessage("Mira, I want to change the langage"), "wichToChangeTheme": MessageLookupByLibrary.simpleMessage("Mira, I want to change the topic"), "yes": MessageLookupByLibrary.simpleMessage("Yes")};
}
