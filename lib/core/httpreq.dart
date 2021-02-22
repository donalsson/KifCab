import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'global.dart' as global;
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kifcab/core/preference.dart';
import '../models/UserMod.dart';

var userinfos = new List<UserMod>();

class HttpPostRequest {
  static Future<dynamic> login_request(phone) async {
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
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //   prefs.setString("userinfos", myresponse["user"]);
          Iterable list0 =
              jsonDecode("[" + jsonEncode(myresponse["user"]) + "]");
          userinfos = list0.map((model) => UserMod.fromJson(model)).toList();
          //   log(userinfos[0].telephone.toString());
          global.userinfos = userinfos[0];
          return myresponse["user"];
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
          "gamme": "8",
          "long_d": deplon,
          "lat_d": deplat,
          "long_a": arrivlon,
          "lat_a": arrivlat
        });
    if (response.statusCode == 200) {
      print("response.bodyddd");
      log(response.body);
      var myresponse = jsonDecode(response.body);
      log(jsonEncode(myresponse['commande']));
      // print(myresponse['chauffeur']['description'].toString());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("getchauf", "1");
      fcmsendmessage(
          "Nouvelle commande",
          "Vous avez une nouvelle commande disponible",
          jsonEncode(myresponse['commande']),
          myresponse['chauffeur']['description'].toString(),
          "1");
      return myresponse;
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<dynamic> fcmsendmessage(
      title, message, datau, token, etat) async {
    // String urli = 'https://small-pocket.herokuapp.com/api/v1/auth/sign_in';
    // var url = '${urli}ocr';
    // var bytes = image.readAsBytesSync();
    log("token" + token);
    // log("data" + datau);
    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": token,
      "notification": {
        "title": title,
        "body": message,
      },
      "data": {
        "commande": datau,
        "userln": global.longitude,
        "etat": etat,
        "userlat": global.latitude,
        "username": global.userinfos.nom,
        "usertoken": global.fcmtoken,
        "userphone": global.userinfos.telephone,
        "userpro": global.userinfos.photo
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': global.fcmtokenauto // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(postUrl,
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);
    print(response.body);
    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }

/*
AAAA3OBUsXw:APA91bF7g_X1nsoT67A8quk4Rx49btZQvt3ACXGeetfVjxGzLvJuDoEkVjSlRiNkG48e-lhj92upoBsL_18R8N6RcxJWaRmxi_cvFyOG_zT3als1fkET9yog-22qfeJeCA0t2-APc4nu
*/
  static Future<String> sendposition_request(lat, lon, idcompte, token) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);
    print(token);
    http.Response response = await httpp.post(
        'https://149.202.47.143/index.php/webservice/SendPosition',
        body: {
          "longitude": lat,
          "latitude": lon,
          "id_compte": idcompte,
          "token": token
        });
    if (response.statusCode == 200) {
      print("response.body");
      print(response.body);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<dynamic> getCurrentOperation(idcompte) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);

    http.Response response = await httpp.post(
        'https://149.202.47.143/index.php/webservice/currentOperation',
        body: {"id": idcompte, "driver": "false"});
    if (response.statusCode == 200) {
      print("get current");
      var myresponse = jsonDecode(response.body);
      if (myresponse["result"].toString() != "[]") {
        log("send Current operation chauf");
      }
      return myresponse["result"];
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<String> noteChauffeur(idoffre, idcommande, point) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);

    http.Response response = await httpp
        .post('https://149.202.47.143/index.php/webservice/markUser', body: {
      "pos": idoffre,
      "cmd": idcommande,
      "point": point,
      "client": 'true'
    });
    if (response.statusCode == 200) {
      print("get noteee");
      print(response.body);

      return response.body;
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<String> processOperation(
    action,
    id,
    type,
  ) async {
    final ioc = new HttpClient();
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final httpp = new IOClient(ioc);

    http.Response response = await httpp.post(
        'https://149.202.47.143/index.php/webservice/processOperation/' +
            action,
        body: {"id": id});
    if (response.statusCode == 200) {
      print("get changesss");
      print(response.body);
      if (action == "remove") {
        fcmsendmessage(
            "Commande Annulée",
            "Cette Commande a été annuller par le client",
            "",
            global.chauffeur['description'].toString(),
            "0");
      }
      return response.body;
    } else {
      throw Exception('Failed to load album');
    }
  }
//flQU6tLfQnebmIhhyZ_vcR:APA91bH5YE32F08BrZ_kHg7jd-a3R79fNwCc4Mt_Wt2BB44XJmNTNQf63f7sRqlmk_bUZFdrIsBwdJFA6iQcfm3MEQ393WddgkJ4RWmkRpcVI_L7iBGMZLymbiSJQUQltVumudmNUwuD

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
          Iterable list0 = jsonDecode(myresponse["user"]);
          userinfos = list0.map((model) => UserMod.fromJson(model)).toList();
          log(userinfos[0].telephone.toString());
          global.userinfos = userinfos[0];
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
        Iterable list0 = jsonDecode("[" + jsonEncode(myresponse["user"]) + "]");
        userinfos = list0.map((model) => UserMod.fromJson(model)).toList();
        log(userinfos[0].telephone.toString());
        global.userinfos = userinfos[0];
        return myresponse["user"]["mot_de_passe"];
      } else {
        return "error";
      }
    } else {
      throw Exception('Failed to load album');
    }
  }
}
