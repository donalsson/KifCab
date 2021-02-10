import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kifcab/core/preference.dart';

class HttpPostRequest {
  static Future<String> login_request(phone) async {
    // String urli = 'https://small-pocket.herokuapp.com/api/v1/auth/sign_in';
    // var url = '${urli}ocr';
    // var bytes = image.readAsBytesSync();

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);
    http.Response response = await httpp.post(
        'https://149.202.47.143/index.php/webservice/login',
        body: {"telephone": phone});
    if (response.statusCode == 200) {
      var myresponse = jsonDecode(response.body);
      print(response.body);
      print(jsonEncode(myresponse["user"]));
      var error = myresponse["error"];
      print("token");
      if (error.toString() == "true") {
        print(error.toString());
        return "error";
      } else {
        if (myresponse["user"]["type"] == "1") {
          return "notallow";
        } else {
          SharedPreferencesClass.save(
              "userinfos", "[" + jsonEncode(myresponse["user"]) + "]");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //   prefs.setString("userinfos", myresponse["user"]);
          return myresponse["user"]["mot_de_passe"];
        }
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<dynamic> saveoperations_request(type, iduser, cout, depart,
      arriver, gamme, deplon, deplat, arrivlon, arrivlat, distance) async {
    // String urli = 'https://small-pocket.herokuapp.com/api/v1/auth/sign_in';
    // var url = '${urli}ocr';
    // var bytes = image.readAsBytesSync();

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);
    http.Response response = await httpp.post(
        'https://149.202.47.143/index.php/webservice/saveOperation',
        body: {
          "type": type,
          "compte": iduser,
          "cout": cout,
          "depart": depart,
          "arrive": arriver,
          "gamme": gamme,
          "long_d": deplon,
          "lat_d": deplat,
          "long_a": arrivlon,
          "lat_a": arrivlat,
          "distance": distance
        });
    if (response.statusCode == 200) {
      var myresponse = jsonDecode(response.body);
      print(response.body);
      /* print(jsonEncode(myresponse["user"]));
      var error = myresponse["error"];
      print("token");
      if (error.toString() == "true") {
        print(error.toString());
        return "error";
      } else {
        if (myresponse["user"]["type"] == "1") {
          return "notallow";
        } else {
          SharedPreferencesClass.save(
              "userinfos", "[" + jsonEncode(myresponse["user"]) + "]");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //   prefs.setString("userinfos", myresponse["user"]);
          return myresponse["user"]["mot_de_passe"];
        }
      }*/
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<String> sendposition_request(lat, lon, idcompte) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);
    http.Response response = await httpp.post(
        'https://149.202.47.143/index.php/webservice/SendPosition',
        body: {"longitude": lat, "latitude": lon, "id_compte": idcompte});
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<dynamic> login_recup(phone) async {
    // String urli = 'https://small-pocket.herokuapp.com/api/v1/auth/sign_in';
    // var url = '${urli}ocr';
    // var bytes = image.readAsBytesSync();

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);
    http.Response response = await httpp.post(
        'https://149.202.47.143/index.php/webservice/loginrecup',
        body: {"telephone": phone});
    if (response.statusCode == 200) {
      print(response.body);
      var myresponse = jsonDecode(response.body);
      var error = myresponse["error"];
      print("token");
      if (error.toString() == "true") {
        print(error.toString());
        return "error";
      } else {
        if (myresponse["user"]["type"] == "1") {
          return "notallow";
        } else {
          return myresponse["user"];
        }
      }
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<String> register_request(nom, email, tel, ville) async {
    // String urli = 'https://small-pocket.herokuapp.com/api/v1/auth/sign_in';
    // var url = '${urli}ocr';
    // var bytes = image.readAsBytesSync();

    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);
    http.Response response = await httpp
        .post('https://149.202.47.143/index.php/webservice/register', body: {
      "nom": nom,
      "telephone": tel,
      "email": email,
      "localisation": ville
    });
    if (response.statusCode == 200) {
      print(response.body);
      var myresponse = jsonDecode(response.body);
      var error = myresponse["error"];
      print("token");
      if (error.toString() == "false") {
        print(error.toString());
        return myresponse["user"]["mot_de_passe"];
      } else {
        return "error";
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
