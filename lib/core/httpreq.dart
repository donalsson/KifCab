import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.Dart' as http;
import 'package:http/io_client.dart';

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
      // print(response.body);
      var myresponse = jsonDecode(response.body);
      var error = myresponse["error"];
      print("token");
      if (error.toString() == "true") {
        print(error.toString());
        return "error";
      } else {
        return myresponse["user"]["mot_de_passe"];
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
