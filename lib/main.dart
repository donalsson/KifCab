import 'dart:convert';
import 'dart:developer';

import 'package:kifcab/screens/course_screen.dart';
import 'package:kifcab/screens/drawers/about_screen.dart';
import 'package:kifcab/screens/drawers/account_screen.dart';
import 'package:kifcab/screens/drawers/become_driver_screen.dart';
import 'package:kifcab/screens/drawers/cgi_screen.dart';
import 'package:kifcab/screens/drawers/help_screen.dart';
import 'package:kifcab/screens/location_screen.dart';

import 'core/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/screens/depot_screen.dart';
import 'package:kifcab/screens/home_screen.dart';
import 'package:kifcab/screens/index.dart';
import 'package:kifcab/screens/login_screen.dart';
import 'package:kifcab/screens/register_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kifcab/screens/welcome_screen.dart';
import 'core/preference.dart';
import 'models/UserMod.dart';
import 'package:kifcab/constant.dart';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool compteU = false;
  await SharedPreferencesClass.restoreuser("userinfos").then((value) {
    var userinfos = new List<UserMod>();
    log("valuee");
    if (value != "") {
      compteU = true;
      Iterable list0 = jsonDecode(value);
      userinfos = list0.map((model) => UserMod.fromJson(model)).toList();
      log(userinfos[0].telephone.toString());
      runApp(MyApp(compteU));
    } else {
      log("not conected");
      runApp(MyApp(compteU));
    }
  });
}

class MyApp extends StatelessWidget {
  bool _dartMode = false;
  UserMod userinfos;
  bool compteU;
  AppLocalizationDelegate _localeOverrideDelegate = AppLocalizationDelegate(DEFAULT_LOCALE);

  MyApp(this.compteU);

  // This widget is the root of your application.
  //        Navigator.pushReplacementNamed(context, '/home', arguments: {'conversation': conversation});

  ThemeData getTheme({bool darkMode: false}) {
    // if (darkMode) {
    return ThemeData(primarySwatch: Colors.blue, visualDensity: VisualDensity.adaptivePlatformDensity, brightness: Brightness.dark, fontFamily: DEFAULT_FONT_FAMILY);
    /*  } else {
      return ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          fontFamily: DEFAULT_FONT_FAMILY);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
        overlayWidget: Center(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset('assets/load.gif', height: 35),
          ),
        ),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Kifcab',
            darkTheme: ThemeData.dark(),
            theme: getTheme(darkMode: _dartMode),
            //home: MyHomePage(title: 'Flutter Demo Home Page'),
            localizationsDelegates: [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, _localeOverrideDelegate],
            supportedLocales: SUPPORTED_LOCALES,
            initialRoute: '/home',
            //initialRoute: compteU == false ? '/welcome' : '/home',
            routes: {
              // When navigating to the "/plash" route, build the SecondScreen widget.
              '/register': (context) => RegisterScreen(),
              '/login': (context) => LoginScreen(),
              '/welcome': (context) => WelcomeScreen(),
              '/home': (context) => HomeScreen(),
              '/depot': (context) => DepotScreen(),
              '/course': (context) => CourseScreen(),
              '/location': (context) => LocationScreen(),
              '/help': (context) => HelpScreen(),
              '/about': (context) => AboutScreen(),
              '/cgi': (context) => CgiScreen(),
              '/profile': (context) => BecomeDriverScreen(),
              '/account': (context) => AccountScreen(),
              '/become-driver': (context) => BecomeDriverScreen(),
            }));
  }
}
