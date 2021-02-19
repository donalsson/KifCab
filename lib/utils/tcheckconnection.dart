import 'dart:io';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

import 'package:kifcab/screens/notconnect.dart';

bool enter = false;

void techkconnection(context) {
  var listener = DataConnectionChecker().onStatusChange.listen((status) async {
    switch (status) {
      case DataConnectionStatus.connected:
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            print('Data connection is available.');
            print('Data connection is availabljkjkjke.');
            if (enter == true) {
              Navigator.pop(context);
            }
            enter = false;
          }
        } on SocketException catch (_) {
          print('You are disconnected from the internet.');
          if (enter == false) {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (_, __, ___) => new Notconectscreen()));
          }
          enter = true;
        }

        break;
      case DataConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        if (enter == false) {
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (_, __, ___) => new Notconectscreen()));
        }
        enter = true;
        break;
    }
  });
}
