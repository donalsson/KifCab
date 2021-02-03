 import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
     static Future restore(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
   
    sharedPrefs.setBool('languecc', true);
    return (sharedPrefs.get(key) ?? false);
  }
 static Future restoreuser(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
   
    sharedPrefs.setBool('languecc', true);
    return (sharedPrefs.get(key) ?? "");
  }
  static Future restoreUserVal(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    return (sharedPrefs.get(key) ?? false);
  }


 static Future restorelanguage(String key) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
   // sharedPrefs.setBool('initialized', true);
    return (sharedPrefs.get(key) ?? 'fr');
  }

  static save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }
}