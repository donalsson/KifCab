import 'dart:io';
import 'dart:async';
import 'package:kifcab/core/httpreq.dart';
import '../core/global.dart' as globals;
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kifcab/screens/notconnect.dart';

import 'package:kifcab/library/loader.dart';

bool enter = false;
Timer _timer;
int _start = 10;
double longitude;
double latitude;

void getCurrent(context) {
  HttpPostRequest.getCurrentOperation(globals.userinfos.id_compte)
      .then((dynamic result) async {
    print(result);
    if (result.toString() == "[]") {
      print("not current operation");
    } else {
      print("nnok");
    }
  });
}
