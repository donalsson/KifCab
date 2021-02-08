import 'dart:io';
import 'dart:async';

import '../core/global.dart' as globals;
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kifcab/screens/notconnect.dart';

bool enter = false;
Timer _timer;
int _start = 10;
double longitude;
double latitude;

void getandsendposition(context) {
  const oneSec = const Duration(seconds: 5);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) async {
      await Geolocator.getCurrentPosition().then((value) => {
            print(value.longitude.toString())

            /*     _positionItems.add(_PositionItem(
                            _PositionItemType.position, value.toString()))*/
          });
      print("detttt_____get");
      print(globals.userinfos.nom.toString());
    },
  );
}
