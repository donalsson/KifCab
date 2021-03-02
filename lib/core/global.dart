library my_project.global;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import '../models/UserMod.dart';
import '../models/GammesModel.dart';

// set default values for the initial run
double longitude;
double latitude;
String type = "";
String active;
double chauflat = 0;
double chaufln;
String chaufname;
String chaufprof;
String chauffcmtoken;
String chauftel;
int depodure;
int depoprix;
String depodistance;
var commande;
var offre;
var chauffeur;
var priceconst;
List<GammesModel> coursegammes;
List<GammesModel> depogammes;
List<GammesModel> locagammes;
String idcommande = "";
String fcmtoken = "";
String fcmtokenauto =
    "key=AAAA3OBUsXw:APA91bF7g_X1nsoT67A8quk4Rx49btZQvt3ACXGeetfVjxGzLvJuDoEkVjSlRiNkG48e-lhj92upoBsL_18R8N6RcxJWaRmxi_cvFyOG_zT3als1fkET9yog-22qfeJeCA0t2-APc4nu";
UserMod userinfos;
Location location = new Location(4.024394577478441, 9.705471602732858);
String pass = '';
