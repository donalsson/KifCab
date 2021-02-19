library my_project.global;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import '../models/UserMod.dart';

// set default values for the initial run
double longitude = 5.1;
double latitude = 9.0;
UserMod userinfos;
Location location = new Location(4.024394577478441, 9.705471602732858);
String pass = '';
