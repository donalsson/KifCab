import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'dart:convert';
import 'package:marquee/marquee.dart';
import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_button.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/widgets/card_button.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/global.dart' as globals;
import '../core/preference.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kifcab/library/loader.dart';
import 'package:kifcab/screens/driversdetaild.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'dart:math' show cos, sqrt, asin;
import 'home_screen.dart';
import 'package:kifcab/core/httpreq.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kifcab/utils/tcheckconnection.dart';
import 'package:kifcab/utils/getandsendpossition.dart';

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  final dynamic data = message['data'] ?? message;
  final String itemId = data['id'];
  final Item item = _items.putIfAbsent(itemId, () => Item(itemId: itemId))
    ..status = data['status'];
  return item;
}

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }
}

class MapView extends StatefulWidget {
  String depname, arrivname;
  double depln, deplat, arrivlat, arrivln;
  int prixt;
  MapView({
    Key key,
    this.depname,
    this.deplat,
    this.prixt,
    this.depln,
    this.arrivname,
    this.arrivlat,
    this.arrivln,
  }) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

double longitude;
double lonch = 0;
int ii = 0;
int iii = 0;
int iiii = 0;
int val = 0;
int val11 = 0;
int end = 0;
int endd = 0;
int heurep = 0;
int heurer = 0;
int minp = 0;
int minr = 0;
int secp = 0;
int secrp = 0;
bool isminus = false;

bool noteerror = false;
double latitude;
double latch;
String depart = "";
String arrive = "";
String idc = "";
String idoffre = "";

class _MapViewState extends State<MapView> with TickerProviderStateMixin {
  _MapViewState();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  double distance;
  Position _currentPosition;
  String _currentAddress;
  String messagech = "";
  int prix = 0;
  String gammes = "Bronse";
  int i = 0;
  int note = 0;
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  AudioCache audioCache = AudioCache();
  Position startCoordinates;
  Position destinationCoordinates;
  Position startCoordinates1;
  Position destinationCoordinates1;
  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();
  AnimationController _controller;
  int levelClock = 0;
  String _placeDistance = " ";
  String _placeDistance1 = " ";
  String timesspass = " ";
  String timesrest = " ";
  String _placeDistancek = "";
  String idoffre = "";

  Timer _timer;
  Timer _timer11;
  Timer _waitrefustimer;
  Set<Marker> markers = {};
  BitmapDescriptor customIcon1;

  BitmapDescriptor customIcon2;
  BitmapDescriptor depmarker;
  BitmapDescriptor arivmarker;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<LatLng> polylineCoordinates = [];
  List<LatLng> polylineCoordinates1 = [];
  int _selectedRange = 0;
  int _selectedPayment = 0;
  int _timess = 0;
  int _timess1 = 0;
  int _dueedep = 0;
  bool visible = false;
  bool visiblenote = false;
  bool visiblenoteload = false;
  Locale locale;
  var format;
  @override
  void initState() {
    if (globals.active == "3") {
      timewhatch();
    }

    initSaveData();
    initSaveDataCloud();
    prix = widget.prixt;
    if (globals.active == "1") {
      waitrefus();
    }
    //locale = Localizations.localeOf(context);
    super.initState();
    //Timer.run(() => _calculateDistance());
  }

  Widget _buildDialog(BuildContext context, Item item) {
    return AlertDialog(
      content: Text("Item ${item.itemId} has been updated"),
      actions: <Widget>[
        FlatButton(
          child: const Text('CLOSE'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: const Text('SHOW'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }

  void _showItemToMap(Map<String, dynamic> message) {
    // message
    log("do1");
    setState(() {
      globals.active = "2";

      var offre = jsonDecode(message["data"]["commande"]);
      /* 
      var vehicule = jsonDecode(message["data"]["vehicule"][0]);
      globals.vehicule = vehicule;
      globals.images.add(vehicule["photo1"]);
      globals.images.add(vehicule["photo2"]);
      globals.images.add(vehicule["photo3"]);
      globals.images.add(vehicule["photo4"]);
      globals.images.add(vehicule["photo5"]);
      */
      globals.offre = offre;
      globals.chaufprof = message["data"]["userpro"];
      latch = double.parse(message["data"]["userlat"]);
      lonch = double.parse(message["data"]["userln"]);

      globals.chauffcmtoken = message["data"]["usertoken"];
      globals.chauftel = message["data"]["usertel"];
      globals.chaufln = double.parse(message["data"]["userln"]);
      globals.chauflat = double.parse(message["data"]["userlat"]);
      globals.chaufname = message["data"]["username"];
    });
    log('message["data"]["userln"]');
    log(message["data"]["userlat"]);
    log(message["data"]["userpro"]);

    _calculateDistance10("a", double.parse(message["data"]["userlat"]),
        double.parse(message["data"]["userln"]));
  }

  void _navigateToItemDetail(Map<String, dynamic> message) {
    final Item item = _itemForMessage(message);
    // Clear away dialogs
  }

  Future<AudioPlayer> playLocalAsset() async {
    audioCache.play('notif.mp3');
  }

  timewhatch() async {
    SharedPreferences shared = await SharedPreferences.getInstance();

    int tempdeb = shared.getInt("tempdeb");

    int tempnow = DateTime.now().millisecondsSinceEpoch;
    int durercom;
    if (globals.type == "COURSE") {
      durercom = int.parse(globals.commande["heure"]) * 60 * 60 * 1000;
      log("dureeeecom  " + durercom.toString());

      int temppasse = tempnow - tempdeb - 3600000;
      int temprestant = durercom - temppasse - 3600000 - 3600000;
      int h = 0;
      if (globals.active == "3") {
        const oneSec = const Duration(seconds: 1);
        _timer = new Timer.periodic(oneSec, (Timer timer) async {
          h = h + 1;
          // log("tempfinnng  :" + globals.depodure.toString());
          setState(() {
            timesspass = inttohour(temppasse + (h * 1000));
            timesrest = inttohour(temprestant - (h * 1000));
          });
        });
      }
    } else {
      int h = 0;
      if (globals.active == "3") {
        const oneSec = const Duration(seconds: 1);
        _timer = new Timer.periodic(oneSec, (Timer timer) async {
          h = h + 1;
          durercom = _timess * 60 * 1000;
          int temppasse = tempnow - tempdeb - 3600000;
          int temppasse1 = tempnow - tempdeb;
          int tempfin = tempdeb + durercom;
          int temprestant = durercom - temppasse - 3600000 - 3600000;
          // log("tempfinnng  :" + globals.depodure.toString());
          setState(() {
            timesspass = inttohour(temppasse + (h * 1000));
            if ((tempdeb + temppasse1 + (h * 1000)) < (tempfin)) {
              timesrest = inttohour(
                  (durercom - temppasse - 3600000 - 3600000) - (h * 1000));
            } else {
              isminus = true;
              timesrest = "- " + inttohour((temppasse + (h * 1000) - durercom));
            }
          });
        });
      }
    }
  }

  inttohour(temps) {
    log("tempsss  ::" + temps.toString());
    return (DateFormat('HH:mm:ss')
        .format(new DateTime.fromMillisecondsSinceEpoch(temps)));
  }

  cleanMapp(context) {
    print("cleann");

    setState(() {
      globals.active = "0";
      markers.removeWhere((element) => element.markerId.value == '1');
      markers.removeWhere((element) => element.markerId.value == '22');
      markers.removeWhere(
          (element) => element.markerId.value == '$startCoordinates');
      markers.removeWhere(
          (element) => element.markerId.value == '$destinationCoordinates');
    });
    polylineCoordinates.clear();
  }

  waitrefus() {
    if (globals.active == "1") {
      const oneSec = const Duration(seconds: 5);
      _timer11 = new Timer.periodic(oneSec, (Timer timer) async {
        endd = endd + 1;

        if (endd == 5) {
          _timer11.cancel();
        }
      });
    }
    int iop = 0;
    const oneSec = const Duration(seconds: 1);
    _waitrefustimer = new Timer.periodic(oneSec, (Timer timer) async {
      iop = iop + 1;
      if (end == 40 || end == 80 || end == 120 || end == 160 || end == 200) {
        if (globals.active == "1") {
          refuss();
        }
      } else {
        if (iop == 5) {
          iop = 0;
          /*  HttpPostRequest.fcmsendmessage(
              "Nouvelle commande",
              "Vous avez une nouvelle commande disponible",
              jsonEncode(globals.commande),
              globals.chauffeur['description'].toString(),
              "1");
              */
        }
      }
      end = end + 1;
    });
  }

  refuss() async {
    String sql;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sql = sharedPreferences.getString('sql') ?? "";
    sql = sql.toString() +
        " AND description != '" +
        globals.chauffeur["description"] +
        "' ";

    sharedPreferences.setString('sql', sql);

    HttpPostRequest.getnextchauf(sql, globals.commande['gamme'], globals.type)
        .then((dynamic result) async {
      print("getnextchauf rsultttt");
      print(result);
      if (result == "error") {
        _waitrefustimer.cancel();

        return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.white,
            content: Text(
              "Tous les chauffeurs de cette gamme ne sont pas disponibles; veuillez réessayer dans quelques minutes ou changer de gamme.",
              style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 17),
            ),
            actions: <Widget>[
              FlatButton(
                minWidth: 100.0,
                height: 30,
                color: MyTheme.button,
                onPressed: () {
                  SharedPreferencesClass.save("poscommande", "");
                  Navigator.of(ctx).pop();

                  setState(() {
                    visible = true;
                  });
                  HttpPostRequest.processOperation(
                          "remove", globals.idcommande.toString(), "")
                      .then((String result) async {
                    print("quellll rsultttt");
                    print(result);

                    setState(() {
                      visible = false;
                    });
                    if (result == "null") {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false);
                    }

                    // createMarker(context, value.latitude, value.longitude);
                  });
                },
                child: Text(
                  "Ok",
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
              ),
            ],
            elevation: 12.0,
          ),
        );
      } else {
        int endd = 0;
        if (globals.active == "1") {
          /*  const oneSec = const Duration(seconds: 5);
          _timer11 = new Timer.periodic(oneSec, (Timer timer) async {
            endd = endd + 1;*/
          HttpPostRequest.fcmsendmessage(
              "Nouvelle commande",
              "Vous avez une nouvelle commande disponible",
              jsonEncode(globals.commande),
              result['chauffeur']['description'].toString(),
              "1");
          /*     if (endd == 5) {
              _timer11.cancel();
            }
          });*/
        }
      }
      // createMarker(context, value.latitude, value.longitude);
    });
  }

  processNotificationM(message, BuildContext context) async {
    log('processNotificationM');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (message["data"]["etat"] == "refus") {
        //refuss();
        setState(() {
          end = 40;
        });
        if (globals.active != "1") {
          globals.active = "1";
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.white,
              content: Text(
                "Votre chauffeur ne peux pas venir vous chercher que désirez vous ?",
                style: Theme.of(context).textTheme.headline6.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              actions: <Widget>[
                FlatButton(
                  minWidth: 100.0,
                  height: 30,
                  color: Colors.red[400],
                  onPressed: () {
                    setState(() {
                      visible = true;
                    });
                    HttpPostRequest.processOperation(
                            "remove", globals.idcommande.toString(), "")
                        .then((String result) async {
                      print("quellll rsultttt");
                      print(result);

                      setState(() {
                        visible = false;
                      });
                      if (result == "null") {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      }

                      // createMarker(context, value.latitude, value.longitude);
                    });
                    //
                  },
                  child: Text(
                    "Annuler",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 17),
                  ),
                ),
                FlatButton(
                  minWidth: 100.0,
                  height: 30,
                  color: Colors.green[400],
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    "Un autre",
                    style: Theme.of(context).textTheme.headline6.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                ),
              ],
              elevation: 12.0,
            ),
          );
        }
      }
      if (message["data"]["etat"] == "position") {
        sharedPreferences.setString('sql', "");

        var vehicule = jsonDecode(message["data"]["vehicule"]);
        // log("gogogogo vehicule" + vehicule[0].toString());

        globals.vehicule = vehicule[0];
        /*  globals.images.add(vehicule[0]["photo1"]);
        globals.images.add(vehicule[0]["photo2"]);
        globals.images.add(vehicule[0]["photo3"]);
        globals.images.add(vehicule[0]["photo4"]);
        globals.images.add(vehicule[0]["photo5"]);
*/
        setState(() {
          globals.chaufln = double.parse(message["data"]["userln"]);
          globals.chauflat = double.parse(message["data"]["userlat"]);
        });
        createroutechaufclient(double.parse(message["data"]["userlat"]),
            double.parse(message["data"]["userln"]));
        updatepositionChauffeur(double.parse(message["data"]["userlat"]),
            double.parse(message["data"]["userln"]));
      } else {
        if (message["data"]["etat"] == "3") {
          playLocalAsset();
          SharedPreferences shared = await SharedPreferences.getInstance();
          shared.setInt("tempdeb", DateTime.now().millisecondsSinceEpoch);
          shared.setInt("tempfin", globals.depodure);
          setState(() {
            globals.active = "3";
          });

          timewhatch();
          sharedPreferences.setString('sql', "");
          updatepositionChauffeur(double.parse(message["data"]["userlat"]),
              double.parse(message["data"]["userln"]));
        } else {
          if (message["data"]["etat"] == "4") {
            playLocalAsset();

            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setString(
                "non_note", globals.commande["id_commande"].toString());
            sharedPreferences.setString(
                "offre", globals.offre["id_offre"].toString());
            sharedPreferences.setString('sql', "");

            setState(() {
              globals.active = "4";
              visiblenote = true;
            });
            updatepositionChauffeur(double.parse(message["data"]["userlat"]),
                double.parse(message["data"]["userln"]));
          } else {
            if (message["data"]["etat"] == "2") {
              _showItemToMap(message);
              createroutechaufclient(double.parse(message["data"]["userlat"]),
                  double.parse(message["data"]["userln"]));
              sharedPreferences.setString('sql', "");
              playLocalAsset();

              updatepositionChauffeur(double.parse(message["data"]["userlat"]),
                  double.parse(message["data"]["userln"]));
            } else {
              // _showItemToMap(message);
            }
          }
        }
      }
    } catch (e) {
      print('ERROR PROCESSING NOTIFICATION');
      print(e);
    }
  }

  processNotification(message, BuildContext context) async {
    log('processNotification');
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String lastMessageId = sharedPreferences.getString('last_message_id');
      String currentMessageId = message['data']['google.message_id'];

      //COMPARE NOTIFICATIONS ID
      if (currentMessageId != lastMessageId) {
        //SET LAST NOTIFICATION ID
        if (message["data"]["etat"] == "refus") {
          setState(() {
            end = 40;
          });
        }

        sharedPreferences.setString('last_message_id', currentMessageId);
        if (message["data"]["etat"] == "position") {
          var vehicule = jsonDecode(message["data"]["vehicule"]);
          log("gogogogo vehicule" + vehicule[0].toString());

          globals.vehicule = vehicule[0];
          globals.images.add(vehicule[0]["photo1"]);
          globals.images.add(vehicule[0]["photo2"]);
          globals.images.add(vehicule[0]["photo3"]);
          globals.images.add(vehicule[0]["photo4"]);
          globals.images.add(vehicule[0]["photo5"]);
          sharedPreferences.setString('sql', "");
          setState(() {
            globals.chaufln = double.parse(message["data"]["userln"]);
            globals.chauflat = double.parse(message["data"]["userlat"]);
          });
          /*createroutechaufclient(double.parse(message["data"]["userlat"]),
              double.parse(message["data"]["userln"]));*/
          updatepositionChauffeur(double.parse(message["data"]["userlat"]),
              double.parse(message["data"]["userln"]));
        } else {
          playLocalAsset();
          if (message["data"]["etat"] == "3") {
            setState(() {
              globals.active = "3";
            });

            SharedPreferences shared = await SharedPreferences.getInstance();
            shared.setInt("tempdeb", DateTime.now().millisecondsSinceEpoch);
            shared.setInt("tempfin", globals.depodure);
            timewhatch();
            sharedPreferences.setString('sql', "");

            updatepositionChauffeur(double.parse(message["data"]["userlat"]),
                double.parse(message["data"]["userln"]));
          } else {
            if (message["data"]["etat"] == "4") {
              sharedPreferences.setString('sql', "");
              setState(() {
                globals.active = "4";
                visiblenote = true;
              });
              updatepositionChauffeur(double.parse(message["data"]["userlat"]),
                  double.parse(message["data"]["userln"]));
            } else {
              //_showItemToMap(message);
            }
          }
        }
      }
    } catch (e) {
      print('ERROR PROCESSING NOTIFICATION');
      print(e);
    }
  }

  void initSaveDataCloud() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        log("onMessage: $message");
        processNotificationM(message, context);
      },
      onLaunch: (Map<String, dynamic> message) async {
        log("onLaunch: $message");
        processNotification(message, context);
      },
      onResume: (Map<String, dynamic> message) async {
        log("onResume: $message");
        processNotification(message, context);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      log("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);

      log("_homeScreenText");
    });
  }

  void initSaveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    idc = sharedPreferences.getString("non_note");
    idoffre = sharedPreferences.getString("offre");
    if (idc != "" && idc != null && globals.active == "4") {
      setState(() {
        visiblenote = true;
        globals.idcommande = idc;
      });
      val = 2;
    } else {
      int deparIndex = widget.depname.indexOf(',');
      depart = widget.depname.substring(0, deparIndex);
      if (globals.type == "RESERVATION") {
        int arrivIndex = widget.arrivname.indexOf(',');
        arrive = widget.arrivname.substring(0, arrivIndex);
      }
    }

    await Geolocator.getCurrentPosition().then((value) => {
          setState(() {
            longitude = value.longitude;
            latitude = value.latitude;
            globals.longitude = value.longitude;
            globals.latitude = value.latitude;
          })

          /*     _positionItems.add(_PositionItem(
                            _PositionItemType.position, value.toString()))*/
        });
  }

  createroutechaufclient(lat, lon) async {
    polylinePoints = PolylinePoints();
    startCoordinates1 = Position(latitude: lat, longitude: lon);
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDh1FbcHS6frPJrEmdqNv12maPKs7ORABk", // Google Maps API Key
      PointLatLng(startCoordinates1.latitude, startCoordinates1.longitude),
      PointLatLng(
          destinationCoordinates1.latitude, destinationCoordinates1.longitude),
      travelMode: TravelMode.driving,
    );
    log("result.toString()");
    log(result.points.toString());
    polylineCoordinates1.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates1.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id1 = PolylineId('polyroute');
    Polyline polyline1;

    polyline1 = Polyline(
      polylineId: id1,
      color: Colors.red,
      points: polylineCoordinates1,
      width: 3,
    );

    double totalDistance0 = 0.0;
    int timed0 = 00;

    for (int i = 0; i < polylineCoordinates1.length - 1; i++) {
      totalDistance0 += _coordinateDistance(
        polylineCoordinates1[i].latitude,
        polylineCoordinates1[i].longitude,
        polylineCoordinates1[i + 1].latitude,
        polylineCoordinates1[i + 1].longitude,
      );
    }
    timed0 += _coordinateTimess(totalDistance0);
    log("fdfdfdf  " + globals.active);
    log(_timess.toString());
    setState(() {
      _placeDistance1 = totalDistance0.toStringAsFixed(2);
      _timess1 = timed0;
      distance = totalDistance0;
      print('DISTANCE: $_placeDistance km');
    });

    polylines[id1] = polyline1;
  }

  updatepositionChauffeur(lat, lon) {
    log("dddd");
    log(lat.toString());
    Marker chauf = Marker(
      markerId: MarkerId('10'),
      icon: customIcon2,
      alpha: 0.5,
      position: LatLng(
        globals.chauflat,
        globals.chaufln,
      ),
      infoWindow: InfoWindow(
        title: 'Start',
        snippet: widget.depname,
      ),
    );

    // Destination Location Marker

    setState(() {
      markers.removeWhere((element) => element.markerId.value == '10');
    });

    // Adding the markers to the list
    markers.add(chauf);
    createroutechaufclient(lat, lon);
  }

  createMarker(context, lat, lon) {
    /*print("customIcon1");
    print(lat);*/

    ii = ii + 1;

    log("_placeDistancek");
    // log(globals.chauflat.toString());
    if (globals.chauflat == 0) {
      Marker f = Marker(
          markerId: MarkerId('1'),
          icon: customIcon1,
          alpha: 0.5,
          position: LatLng(lat, lon),
          infoWindow: InfoWindow(title: 'I am a marker!'));

      markers.removeWhere((element) => element.markerId.value == '1');

      markers.add(f);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lon), zoom: 16)));
    } else {
      if (globals.active == "3" && globals.type == "RESERVATION") {
        Marker f = Marker(
            markerId: MarkerId('1'),
            icon: customIcon2,
            alpha: 0.5,
            position: LatLng(lat, lon),
            infoWindow: InfoWindow(title: 'I am a marker!'));

        markers.removeWhere((element) => element.markerId.value == '1');
        markers.removeWhere((element) => element.markerId.value == '10');

        markers.add(f);
        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? startCoordinates.latitude
                : destinationCoordinates.latitude;
        double minx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? startCoordinates.longitude
                : destinationCoordinates.longitude;
        double maxy =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? destinationCoordinates.latitude
                : startCoordinates.latitude;
        double maxx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? destinationCoordinates.longitude
                : startCoordinates.longitude;

        _southwestCoordinates = Position(latitude: miny, longitude: minx);
        _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

        // Accommodate the two locations within the
        // camera view of the map
/*
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(widget.deplat, widget.depln))));

        mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(widget.deplat, widget.depln), 100));*/
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );
      } else {
        Marker f = Marker(
            markerId: MarkerId('1'),
            icon: customIcon1,
            alpha: 0.5,
            position: LatLng(lat, lon),
            infoWindow: InfoWindow(title: 'I am a marker!'));

        markers.removeWhere((element) => element.markerId.value == '1');

        markers.add(f);
        Position _northeastCoordinates1;
        Position _southwestCoordinates1;

        startCoordinates1 =
            Position(latitude: globals.chauflat, longitude: globals.chaufln);
        destinationCoordinates1 = Position(latitude: lat, longitude: lon);

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny1 =
            (startCoordinates1.latitude <= destinationCoordinates1.latitude)
                ? startCoordinates1.latitude
                : destinationCoordinates1.latitude;
        double minx1 =
            (startCoordinates1.longitude <= destinationCoordinates1.longitude)
                ? startCoordinates1.longitude
                : destinationCoordinates1.longitude;
        double maxy1 =
            (startCoordinates1.latitude <= destinationCoordinates1.latitude)
                ? destinationCoordinates1.latitude
                : startCoordinates1.latitude;
        double maxx1 =
            (startCoordinates1.longitude <= destinationCoordinates1.longitude)
                ? destinationCoordinates1.longitude
                : startCoordinates1.longitude;

        _southwestCoordinates1 = Position(latitude: miny1, longitude: minx1);
        _northeastCoordinates1 = Position(latitude: maxy1, longitude: maxx1);

        // Accommodate the two locations within the
        // camera view of the map
/*
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(widget.deplat, widget.depln))));

        mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(widget.deplat, widget.depln), 100));*/
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates1.latitude,
                _northeastCoordinates1.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates1.latitude,
                _southwestCoordinates1.longitude,
              ),
            ),
            100.0,
          ),
        );
      }
    }
  }

  createMarkeruser(context, lat, lon) {
    print("customIcon1");
    print(lat);

    Marker f = Marker(
        markerId: MarkerId('22'),
        icon: customIcon2,
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(title: 'I am a marker!'));

    //markers.clear();
    setState(() {
      markers.removeWhere((element) => element.markerId.value == '22');
    });
    markers.add(f);
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lon), zoom: 16)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  _calculateDistance10(poll, chauflat, chaufln) async {
    // sleep(Duration: 10);
    //  HttpPostRequest.fcmsendmessage();

    //  sleep(Duration(seconds: 10));
    try {
      // Retrieving placemarks from addresses
      /*List<Location> startPlacemark = await locationFromAddress(widget.depname);
      List<Location> destinationPlacemark =
          await locationFromAddress(widget.arrivname);*/
      log("enter");
      if (chauflat != null && chaufln != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        startCoordinates1 = Position(latitude: chauflat, longitude: chaufln);
        destinationCoordinates1 =
            Position(latitude: globals.latitude, longitude: globals.longitude);

        // Start Location Marker
        Marker chauf = Marker(
          markerId: MarkerId('10'),
          icon: customIcon2,
          alpha: 0.5,
          position: LatLng(
            startCoordinates1.latitude,
            startCoordinates1.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: widget.depname,
          ),
        );

        // Destination Location Marker

        setState(() {
          _placeDistancek = "ok";
          markers.removeWhere((element) => element.markerId.value == '10');
        });

        // Adding the markers to the list
        markers.add(chauf);
        if (poll == "a") {
          print('START COORDINATES: $startCoordinates1');
          print('DESTINATION COORDINATES: $destinationCoordinates1');

          Position _northeastCoordinates1;
          Position _southwestCoordinates1;

          // Calculating to check that the position relative
          // to the frame, and pan & zoom the camera accordingly.
          double miny1 =
              (startCoordinates1.latitude <= destinationCoordinates1.latitude)
                  ? startCoordinates1.latitude
                  : destinationCoordinates1.latitude;
          double minx1 =
              (startCoordinates1.longitude <= destinationCoordinates1.longitude)
                  ? startCoordinates1.longitude
                  : destinationCoordinates1.longitude;
          double maxy1 =
              (startCoordinates1.latitude <= destinationCoordinates1.latitude)
                  ? destinationCoordinates1.latitude
                  : startCoordinates1.latitude;
          double maxx1 =
              (startCoordinates1.longitude <= destinationCoordinates1.longitude)
                  ? destinationCoordinates1.longitude
                  : startCoordinates1.longitude;

          _southwestCoordinates1 = Position(latitude: miny1, longitude: minx1);
          _northeastCoordinates1 = Position(latitude: maxy1, longitude: maxx1);

          // Accommodate the two locations within the
          // camera view of the map
/*
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(userlat, widget.depln))));

        mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(userlat, widget.depln), 100));*/
          mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                northeast: LatLng(
                  _northeastCoordinates1.latitude,
                  _northeastCoordinates1.longitude,
                ),
                southwest: LatLng(
                  _southwestCoordinates1.latitude,
                  _southwestCoordinates1.longitude,
                ),
              ),
              100.0,
            ),
          );
          if (globals.type == "COURSE") {
            await _createPolylines(startCoordinates, destinationCoordinates);
          }
          // Calculating the distance between the start and the end positions
          // with a straight path, without considering any route
          // double distanceInMeters = await Geolocator().bearingBetween(
          //   startCoordinates.latitude,
          //   startCoordinates.longitude,
          //   destinationCoordinates.latitude,
          //   destinationCoordinates.longitude,
          // );

        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  _calculateDistance(poll) async {
    // sleep(Duration: 10);
    //  HttpPostRequest.fcmsendmessage();
    ImageConfiguration configuration1 = createLocalImageConfiguration(context);
    /*    final Uint8List markerIcon =
              await getBytesFromAsset('assets/images/flutter.png', 100);*/
    BitmapDescriptor.fromAssetImage(configuration1, 'assets/dep.png')
        .then((icon) {
      setState(() {
        depmarker = icon;
      });
    });
    ImageConfiguration configuration2 = createLocalImageConfiguration(context);
    /*    final Uint8List markerIcon =
              await getBytesFromAsset('assets/images/flutter.png', 100);*/
    BitmapDescriptor.fromAssetImage(configuration2, 'assets/arriv.png')
        .then((icon) {
      setState(() {
        arivmarker = icon;
      });
    });
    Marker destinationMarker;
    Marker startMarker;
    //  sleep(Duration(seconds: 10));
    try {
      // Retrieving placemarks from addresses
      /*List<Location> startPlacemark = await locationFromAddress(widget.depname);
      List<Location> destinationPlacemark =
          await locationFromAddress(widget.arrivname);*/
      log("enter");
      if (widget.deplat != null && widget.arrivlat != null) {
        log("enter 222");
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        setState(() {
          startCoordinates =
              Position(latitude: widget.deplat, longitude: widget.depln);
          if (globals.type == "RESERVATION") {
            destinationCoordinates =
                Position(latitude: widget.arrivlat, longitude: widget.arrivln);
          }
        });

        // Start Location Marker
        startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          icon: depmarker,
          alpha: 0.5,
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: widget.depname,
          ),
        );
        if (globals.type == "RESERVATION") {
          // Destination Location Marker
          destinationMarker = Marker(
            markerId: MarkerId('$destinationCoordinates'),
            alpha: 0.5,
            position: LatLng(
              destinationCoordinates.latitude,
              destinationCoordinates.longitude,
            ),
            infoWindow: InfoWindow(
              title: 'Destination',
              snippet: widget.arrivname,
            ),
            icon: arivmarker,
          );
        }
        setState(() {
          markers.removeWhere(
              (element) => element.markerId.value == '$startCoordinates');
          if (globals.type == "RESERVATION") {
            markers.removeWhere((element) =>
                element.markerId.value == '$destinationCoordinates');
          }
        });

        // Adding the markers to the list
        markers.add(startMarker);
        if (globals.type == "RESERVATION") {
          markers.add(destinationMarker);
        }
        if (poll == "a") {
          if (globals.type == "RESERVATION") {
            print('START COORDINATES: $startCoordinates');
            print('DESTINATION COORDINATES: $destinationCoordinates');

            Position _northeastCoordinates;
            Position _southwestCoordinates;

            // Calculating to check that the position relative
            // to the frame, and pan & zoom the camera accordingly.
            double miny =
                (startCoordinates.latitude <= destinationCoordinates.latitude)
                    ? startCoordinates.latitude
                    : destinationCoordinates.latitude;
            double minx =
                (startCoordinates.longitude <= destinationCoordinates.longitude)
                    ? startCoordinates.longitude
                    : destinationCoordinates.longitude;
            double maxy =
                (startCoordinates.latitude <= destinationCoordinates.latitude)
                    ? destinationCoordinates.latitude
                    : startCoordinates.latitude;
            double maxx =
                (startCoordinates.longitude <= destinationCoordinates.longitude)
                    ? destinationCoordinates.longitude
                    : startCoordinates.longitude;

            _southwestCoordinates = Position(latitude: miny, longitude: minx);
            _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

            // Accommodate the two locations within the
            // camera view of the map
/*
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(widget.deplat, widget.depln))));

        mapController.animateCamera(CameraUpdate.newLatLngZoom(
            LatLng(widget.deplat, widget.depln), 100));*/
            mapController.animateCamera(
              CameraUpdate.newLatLngBounds(
                LatLngBounds(
                  northeast: LatLng(
                    _northeastCoordinates.latitude,
                    _northeastCoordinates.longitude,
                  ),
                  southwest: LatLng(
                    _southwestCoordinates.latitude,
                    _southwestCoordinates.longitude,
                  ),
                ),
                100.0,
              ),
            );

            // Calculating the distance between the start and the end positions
            // with a straight path, without considering any route
            // double distanceInMeters = await Geolocator().bearingBetween(
            //   startCoordinates.latitude,
            //   startCoordinates.longitude,
            //   destinationCoordinates.latitude,
            //   destinationCoordinates.longitude,
            // );

            await _createPolylines(startCoordinates, destinationCoordinates);

            double totalDistance = 0.0;
            int timed = 00;

            // Calculating the total distance by adding the distance
            // between small segments
            // log("sdsdsd");
            // log(polylineCoordinates.length.toString());

            for (int i = 0; i < polylineCoordinates.length - 1; i++) {
              totalDistance += _coordinateDistance(
                polylineCoordinates[i].latitude,
                polylineCoordinates[i].longitude,
                polylineCoordinates[i + 1].latitude,
                polylineCoordinates[i + 1].longitude,
              );
            }
            timed += _coordinateTimess(totalDistance);
            log("fdfdfdf  " + globals.active);
            globals.depodure = timed;
            log(_timess.toString());
            setState(() {
              _placeDistance = totalDistance.toStringAsFixed(2);
              _timess = timed;
              distance = totalDistance;
              print('DISTANCE: $_placeDistance km');
            });
            if (globals.active == "2") {
              const oneSec = const Duration(seconds: 1);
              _timer = new Timer.periodic(oneSec, (Timer timer) async {
                _timer.cancel();
                createroutechaufclient(globals.chauflat, globals.chaufln);
              });
            }
            return true;
          }

          _calculateDistance("b");
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  int _coordinateTimess(distance) {
    double p = 9.6;
    double c = 23;
    double r1;
    double r2;
    r1 = distance * c;
    r2 = r1 / p;
    setState(() {
      // _selectedRange = 0;
      prix = widget.prixt;
    });
    return (r1 / p).round();
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    log(start.latitude.toString());
    log(destination.latitude.toString());
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDh1FbcHS6frPJrEmdqNv12maPKs7ORABk", // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );
    log("result.toString()");
    log(result.points.toString());
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline;
    if (globals.type == "COURSE") {
      polyline = Polyline(
        polylineId: id,
        color: Colors.red[400],
        points: polylineCoordinates,
        width: 3,
      );
    } else {
      polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 3,
      );
    }

    polylines[id] = polyline;
  }

  /*Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }*/

  @override
  Widget build(BuildContext context) {
    i = i + 1;
    if (i < 3) {
      ImageConfiguration configuration1 =
          createLocalImageConfiguration(context);
      /*    final Uint8List markerIcon =
              await getBytesFromAsset('assets/images/flutter.png', 100);*/
      BitmapDescriptor.fromAssetImage(configuration1, 'assets/dep.png')
          .then((icon) {
        setState(() {
          depmarker = icon;
        });
      });
      ImageConfiguration configuration2 =
          createLocalImageConfiguration(context);
      /*    final Uint8List markerIcon =
              await getBytesFromAsset('assets/images/flutter.png', 100);*/
      BitmapDescriptor.fromAssetImage(configuration2, 'assets/arriv.png')
          .then((icon) {
        setState(() {
          arivmarker = icon;
        });
      });
    }

    if (i == 1) {
      const oneSec = const Duration(seconds: 3);
      _timer = new Timer.periodic(oneSec, (Timer timer) async {
        _calculateDistance("a");
        techkconnection(context);
        timer.cancel();
      });
    }

    if (i == 2) {
      const oneSec = const Duration(seconds: 10);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) async {
          ImageConfiguration configuration =
              createLocalImageConfiguration(context);
          /*    final Uint8List markerIcon =
              await getBytesFromAsset('assets/images/flutter.png', 100);*/
          BitmapDescriptor.fromAssetImage(
                  configuration, 'assets/icon-client.png')
              .then((icon) {
            setState(() {
              customIcon1 = icon;
            });
          });
          ImageConfiguration configuration11 =
              createLocalImageConfiguration(context);
          /*    final Uint8List markerIcon =
              await getBytesFromAsset('assets/images/flutter.png', 100);*/
          BitmapDescriptor.fromAssetImage(
                  configuration11, 'assets/icon-taxi.png')
              .then((icon) {
            setState(() {
              customIcon2 = icon;
            });
          });
          await Geolocator.getCurrentPosition().then((value) => {
                HttpPostRequest.sendposition_request(
                        value.latitude.toString(),
                        value.longitude.toString(),
                        globals.userinfos.id_compte,
                        globals.fcmtoken)
                    .then((String result) async {
                  globals.latitude = value.latitude;
                  globals.longitude = value.longitude;
                  createMarker(context, value.latitude, value.longitude);
                })
                /*     _positionItems.add(_PositionItem(
                            _PositionItemType.position, value.toString()))*/
              });
          /* print("detttt_____get");
      print(globals.userinfos.nom.toString());*/
        },
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyTheme.stripColor,
      drawer: NavigationDrawer(),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: GoogleMap(
                  // myLocationEnabled: true,
                  markers: markers != null ? Set<Marker>.from(markers) : null,
                  mapType: MapType.normal,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(4.024394577478441, 9.705471602732858),
                      zoom: 16),
                  polylines: Set<Polyline>.of(polylines.values),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),
              ),
              val == 0
                  ? Positioned(
                      bottom: 0,
                      child: Container(
                        height: MediaQuery.of(context).size.height + 21,
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromRGBO(0, 0, 0, 0.3),
                        child: Column(
                          children: [
                            Container(
                              height: globals.active == "3"
                                  ? MediaQuery.of(context).size.height - 110
                                  : MediaQuery.of(context).size.height - 70,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  globals.active == "3"
                                      ? Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.5),
                                          margin:
                                              EdgeInsets.fromLTRB(0, 100, 0, 0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Center(
                                            child: globals.type == "COURSE"
                                                ? Column(
                                                    children: [
                                                      Text(
                                                        "Durée de la Course",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyTheme
                                                              .primaryDarkColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "Temps Passé",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  timesspass,
                                                                  style: TextStyle(
                                                                      foreground: Paint()
                                                                        ..style = PaintingStyle.stroke
                                                                        ..strokeWidth = 1
                                                                        ..color = Colors.black,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "Temps Restant",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  timesrest,
                                                                  style: TextStyle(
                                                                      foreground: Paint()
                                                                        ..style = PaintingStyle.stroke
                                                                        ..strokeWidth = 1
                                                                        ..color = Colors.black,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Text(
                                                        "Durée du Dépot",
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: MyTheme
                                                              .primaryDarkColor,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "Temps Passé",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  timesspass,
                                                                  style: TextStyle(
                                                                      foreground: Paint()
                                                                        ..style = PaintingStyle.stroke
                                                                        ..strokeWidth = 1
                                                                        ..color = Colors.black,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2,
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                  "Temps Restant",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  timesrest,
                                                                  style: TextStyle(
                                                                      foreground: Paint()
                                                                        ..style = PaintingStyle.stroke
                                                                        ..strokeWidth = 1
                                                                        ..color = Colors.black,
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.normal),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        )
                                      : Container(),
                                  globals.active == "13"
                                      ? Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 110, 0, 0),
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 70.0,
                                          child: Center(
                                            child: Text(
                                                "Nous transmettons votre commande au chauffeurs le plus proche de vous veuillez patientez s\'il vous plait ... ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    foreground: Paint()
                                                      ..style =
                                                          PaintingStyle.stroke
                                                      ..strokeWidth = 1
                                                      ..color = Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ),
                                        )
                                      : Container(),
                                  globals.active == "2"
                                      ? Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 100, 0, 0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              36,
                                          height: 70.0,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 0, 0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          color: Colors.black,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5,
                                                                  horizontal:
                                                                      20),
                                                          child: Text(
                                                            "Votre chauffeur est à ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        Container(
                                                          color: Colors.white,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              215,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      7),
                                                          child: Text(
                                                            _placeDistance1 +
                                                                " km / " +
                                                                _timess1
                                                                    .toString() +
                                                                " minutes ",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                          ),
                                                        )
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ))
                                      : Container(),
                                  globals.active == "3" &&
                                          globals.type == "COURSE"
                                      ? Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 100.0,
                                          child: ListView(
                                            padding: EdgeInsets.only(top: 50.0),
                                            children: [
                                              Marquee(
                                                text:
                                                    'Bon déplacement avec KifCab, Noublier pas de noter le chauffeur a la fin.         Merci de faire confiance a KifCab ...                             ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                              ),
                                            ].map(_wrapWithStuff).toList(),
                                          ),
                                        )
                                      : Container(),
                                  globals.active == "3" &&
                                          globals.type != "COURSE"
                                      ? Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 70.0,
                                          child: Center(
                                              child: Text(
                                            "Bon déplacement avec KifCab, Noublier pas de noter le chauffeur a la fin. Merci de faire confiance a KifCab ...                             ",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                          )),
                                        )
                                      : Container(),
                                  globals.active == "31" ||
                                          globals.active == "2"
                                      ? Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              20,
                                          margin: globals.active == "1"
                                              ? EdgeInsets.fromLTRB(
                                                  0, 100, 0, 0)
                                              : EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0),
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.8),
                                          child: Column(
                                            children: [
                                              /*  Container(
                                                child: Carousel(
                                                  images: [
                                                    NetworkImage(
                                                        'https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
                                                    NetworkImage(
                                                        'https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
                                                    ExactAssetImage(
                                                        "assets/images/LaunchImage.jpg")
                                                  ],
                                                ),
                                              ),*/
                                              globals.type == "RESERVATION"
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            color: Colors.black,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        20),
                                                            child: Text(
                                                              AppLocalization.of(
                                                                      context)
                                                                  .deposit,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          Container(
                                                            color: Colors.white,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                103,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        7),
                                                            child: Text(
                                                              _placeDistance +
                                                                  " km / " +
                                                                  _timess
                                                                      .toString() +
                                                                  " minutes / " +
                                                                  NumberFormat.simpleCurrency(
                                                                          locale:
                                                                              "fr_FR",
                                                                          name:
                                                                              "",
                                                                          decimalDigits:
                                                                              0)
                                                                      .format(
                                                                          prix) +
                                                                  " Fcfa",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          )
                                                        ],
                                                      ))
                                                  : Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 0, 0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            color: Colors.black,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 5,
                                                                    horizontal:
                                                                        20),
                                                            child: Text(
                                                              AppLocalization.of(
                                                                      context)
                                                                  .course,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                          Container(
                                                            color: Colors.white,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                103,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 4,
                                                                    horizontal:
                                                                        7),
                                                            child: Text(
                                                              globals.commande[
                                                                          "heure"]
                                                                      .toString() +
                                                                  " heure / " +
                                                                  NumberFormat.simpleCurrency(
                                                                          locale:
                                                                              "fr_FR",
                                                                          name:
                                                                              "",
                                                                          decimalDigits:
                                                                              0)
                                                                      .format(int.parse(
                                                                          globals
                                                                              .commande["cout"])) +
                                                                  " Fcfa",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal),
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                              Row(
                                                children: [
                                                  Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 10, 10, 10),
                                                    width: 90.0,
                                                    height: 90.0,
                                                    child: CircleAvatar(
                                                      radius: 40,
                                                      backgroundImage:
                                                          CachedNetworkImageProvider(
                                                              globals
                                                                  .chaufprof),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      RichText(
                                                          text: new TextSpan(
                                                        // Note: Styles for TextSpans must be explicitly defined.
                                                        // Child text spans will inherit styles from parent
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text: 'Nom : ',
                                                              style: new TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          new TextSpan(
                                                              text: globals
                                                                          .offre[
                                                                      "compte"]
                                                                  ["nom"])
                                                        ],
                                                      )),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      RichText(
                                                          text: new TextSpan(
                                                        // Note: Styles for TextSpans must be explicitly defined.
                                                        // Child text spans will inherit styles from parent
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                        children: <TextSpan>[
                                                          new TextSpan(
                                                              text:
                                                                  'Téléphone : ',
                                                              style: new TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          new TextSpan(
                                                              text: globals
                                                                          .offre[
                                                                      "compte"][
                                                                  "telephone"]),
                                                        ],
                                                      )),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text('Chauffeur ',
                                                              style:
                                                                  new TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12,
                                                              )),
                                                          double.parse(globals.offre[
                                                                              "compte"]
                                                                          [
                                                                          "noteChauffeur"])
                                                                      .round() <
                                                                  1
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    print("ok");
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoile.png',
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoilej.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                          double.parse(globals.offre[
                                                                              "compte"]
                                                                          [
                                                                          "noteChauffeur"])
                                                                      .round() <
                                                                  2
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoile.png',
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoilej.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                          double.parse(globals.offre[
                                                                              "compte"]
                                                                          [
                                                                          "noteChauffeur"])
                                                                      .round() <
                                                                  3
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoile.png',
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoilej.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                          double.parse(globals.offre[
                                                                              "compte"]
                                                                          [
                                                                          "noteChauffeur"])
                                                                      .round() <
                                                                  4
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoile.png',
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoilej.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                          double.parse(globals.offre[
                                                                              "compte"]
                                                                          [
                                                                          "noteChauffeur"])
                                                                      .round() <
                                                                  5
                                                              ? InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      prix = 5;
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoile.png',
                                                                    ),
                                                                  ),
                                                                )
                                                              : InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      prix = 5;
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                    width: 24,
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/etoilej.png',
                                                                    ),
                                                                  ),
                                                                ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                    ],
                                                  )),
                                                  Container(
                                                      width: 110,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          5),
                                                              child:
                                                                  RaisedButton(
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                onPressed:
                                                                    () async {
                                                                  launch("tel://" +
                                                                      globals
                                                                          .chauftel);
                                                                },
                                                                color: Color
                                                                    .fromRGBO(
                                                                        191,
                                                                        191,
                                                                        191,
                                                                        1),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        70.0),
                                                                  ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        //color: Color.fromRGBO(229, 188, 1, 1),

                                                                        width:
                                                                            5,
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .phone,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Appeler",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.black,
                                                                                fontSize: 10.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          5,
                                                                          10,
                                                                          5),
                                                              child:
                                                                  RaisedButton(
                                                                materialTapTargetSize:
                                                                    MaterialTapTargetSize
                                                                        .shrinkWrap,
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.of(context).push(PageRouteBuilder(
                                                                      opaque:
                                                                          false,
                                                                      pageBuilder: (_,
                                                                              __,
                                                                              ___) =>
                                                                          new DriverDetails()));
                                                                  //
                                                                },
                                                                color: MyTheme
                                                                    .button,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius.circular(
                                                                        70.0),
                                                                  ),
                                                                ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Row(
                                                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: <
                                                                        Widget>[
                                                                      Container(
                                                                        //color: Color.fromRGBO(229, 188, 1, 1),

                                                                        width:
                                                                            5,
                                                                        height:
                                                                            40,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .details,
                                                                          color:
                                                                              Colors.black,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Détails",
                                                                            style: TextStyle(
                                                                                fontWeight: FontWeight.w400,
                                                                                color: Colors.black,
                                                                                fontSize: 10.0),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                        ],
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            globals.active != "3" && globals.active != "4"
                                ? Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: globals.type == "RESERVATION"
                                            ? Row(
                                                children: [
                                                  Container(
                                                    color: Colors.black,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 7),
                                                    child: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .deposit,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 7),
                                                    child: Text(
                                                      _placeDistance +
                                                          " km / " +
                                                          _timess.toString() +
                                                          " minutes / " +
                                                          NumberFormat.simpleCurrency(
                                                                  locale:
                                                                      "fr_FR",
                                                                  name: "",
                                                                  decimalDigits:
                                                                      0)
                                                              .format(prix) +
                                                          " Fcfa",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Row(
                                                children: [
                                                  Container(
                                                    color: Colors.black,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 7),
                                                    child: Text(
                                                      AppLocalization.of(
                                                              context)
                                                          .course,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  Container(
                                                    color: Colors.white,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 7),
                                                    child: Text(
                                                      globals.commande["heure"]
                                                              .toString() +
                                                          " heure / " +
                                                          NumberFormat.simpleCurrency(
                                                                  locale:
                                                                      "fr_FR",
                                                                  name: "",
                                                                  decimalDigits:
                                                                      0)
                                                              .format(int.parse(
                                                                  globals.commande[
                                                                      "cout"])) +
                                                          " Fcfa",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  )
                                                ],
                                              )),
                                  )
                                : Container(),
                            globals.active == "3" || globals.active == "4"
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 330,
                                      color: Colors.white,
                                      margin: EdgeInsets.fromLTRB(10, 0, 7, 0),
                                      child: globals.type == "RESERVATION"
                                          ? Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        color: Colors.black,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4,
                                                                horizontal: 7),
                                                        child: Text(
                                                          AppLocalization.of(
                                                                  context)
                                                              .deposit,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4,
                                                                horizontal: 7),
                                                        child: Text(
                                                          _placeDistance +
                                                              " km / " +
                                                              _timess
                                                                  .toString() +
                                                              " minutes / " +
                                                              NumberFormat.simpleCurrency(
                                                                      locale:
                                                                          "fr_FR",
                                                                      name: "",
                                                                      decimalDigits:
                                                                          0)
                                                                  .format(
                                                                      prix) +
                                                              " Fcfa",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 330,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 2, 0, 0),
                                                    color: Colors.black12,
                                                    child: RichText(
                                                        text: new TextSpan(
                                                      // Note: Styles for TextSpans must be explicitly defined.
                                                      // Child text spans will inherit styles from parent
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                            text: 'DE ',
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        new TextSpan(
                                                            text: depart),
                                                        new TextSpan(
                                                            text: ' A ',
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        new TextSpan(
                                                            text: arrive),
                                                      ],
                                                    )),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        color: Colors.black,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4,
                                                                horizontal: 7),
                                                        child: Text(
                                                          AppLocalization.of(
                                                                  context)
                                                              .course,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors.white,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4,
                                                                horizontal: 7),
                                                        child: Text(
                                                          globals.commande[
                                                                      "heure"]
                                                                  .toString() +
                                                              " heure / " +
                                                              NumberFormat.simpleCurrency(
                                                                      locale:
                                                                          "fr_FR",
                                                                      name: "",
                                                                      decimalDigits:
                                                                          0)
                                                                  .format(int.parse(
                                                                      globals.commande[
                                                                          "cout"])) +
                                                              " Fcfa",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 330,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 2, 0, 0),
                                                    color: Colors.black12,
                                                    child: RichText(
                                                        text: new TextSpan(
                                                      // Note: Styles for TextSpans must be explicitly defined.
                                                      // Child text spans will inherit styles from parent
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.black),
                                                      children: <TextSpan>[
                                                        new TextSpan(
                                                            text: 'Départ ',
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        new TextSpan(
                                                            text: depart),
                                                        new TextSpan(
                                                            text: ' Durée ',
                                                            style: new TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        new TextSpan(
                                                            text: globals
                                                                        .commande[
                                                                    "heure"] +
                                                                " H"),
                                                      ],
                                                    )),
                                                  )
                                                ],
                                              ),
                                            ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ))
                  : Container(),
              Positioned(
                top: 25,
                right: 0,
                left: 10,
                child: Container(
                  color: Colors.transparent,
                  height: AppBar().preferredSize.height,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: GestureDetector(
                        onTap: () {
                          if (_scaffoldKey.currentState.isDrawerOpen) {
                            _scaffoldKey.currentState.openEndDrawer();
                          } else {
                            _scaffoldKey.currentState.openDrawer();
                          }
                        },
                        child: Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 25,
                        ),
                      )),
                      /*   Container(
                          child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.radio_button_checked,
                          color: Colors.red,
                          size: 20,
                        ),
                      )),*/
                    ],
                  ),
                ),
              ),
              globals.active != "4" && globals.active != "1"
                  ? Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: MyTheme.stripColor,
                        height: 60,
                        child: Row(
                          children: [
                            globals.active != "3"
                                ? NavigationButton(
                                    backColor: MyTheme.primaryColor,
                                    textColor: Colors.black,
                                    icon: Icons.cancel,
                                    text: AppLocalization.of(context).cancel,
                                    onTap: () {
                                      setState(() {
                                        visible = true;
                                      });
                                      HttpPostRequest.processOperation("remove",
                                              globals.idcommande.toString(), "")
                                          .then((String result) async {
                                        print("quellll rsultttt");
                                        print(result);

                                        setState(() {
                                          visible = false;
                                        });
                                        if (result == "null") {
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              HomeScreen()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                        }

                                        // createMarker(context, value.latitude, value.longitude);
                                      });
                                      //
                                    },
                                  )
                                : Container(),
                            globals.active == "2"
                                ? NavigationButton(
                                    backColor: Color(0xFA0c1117),
                                    textColor: Color(0xFAFFFFFF),
                                    icon: Icons.call,
                                    text:
                                        AppLocalization.of(context).callservice,
                                    onTap: () {
                                      //  Navigator.pop(context);
                                      launch("tel://+237699244455");
                                    },
                                  )
                                : Container(),
                            globals.active == "3"
                                ? NavigationButton(
                                    backColor: MyTheme.primaryColor,
                                    textColor: Colors.black,
                                    text: "En route avec KifCab ...",
                                    onTap: () {
                                      //  Navigator.pop(context);
                                      // launch("tel://+237691779906");
                                    },
                                  )
                                : Container(),
                            globals.active != "3"
                                ? NavigationButton(
                                    backColor: Color(0xFA0c1133),
                                    textColor: Color(0xFAFFFFFF),
                                    icon: Icons.refresh_rounded,
                                    text: "Actualiser",
                                    onTap: () {
                                      //  Navigator.pop(context);
                                      setState(() {
                                        visible = true;
                                      });
                                      HttpPostRequest.getCurrentOperation(
                                              globals.userinfos.id_compte)
                                          .then((dynamic result) async {
                                        String arr;
                                        print(result);
                                        if (result.toString() != "null") {
                                          setState(() {
                                            int deparIndex = result["commande"]
                                                    ["depart"]
                                                .indexOf(',');
                                            depart = result["commande"]
                                                    ["depart"]
                                                .substring(0, deparIndex);
                                            if (result["commande"]["type"] ==
                                                "RESERVATION") {
                                              int arrivIndex =
                                                  result["commande"]["arrive"]
                                                      .indexOf(',');
                                              arrive = result["commande"]
                                                      ["arrive"]
                                                  .substring(0, arrivIndex);
                                              arr =
                                                  result["commande"]["arrive"];
                                            } else {
                                              arr = "a";
                                            }
                                            globals.commande =
                                                result["commande"];
                                            globals.idcommande =
                                                result["commande"]
                                                    ["id_commande"];
                                            globals.active =
                                                result["commande"]["statut"];
                                            globals.type =
                                                result["commande"]["type"];
                                            if (result["offres"].toString() !=
                                                "[]") {
                                              globals.offre =
                                                  result["offres"][0];

                                              log("goood");
                                              globals.chauflat = double.parse(
                                                  result["offres"][0]["compte"]
                                                      ["latitude"]);
                                              globals.chaufln = double.parse(
                                                  result["offres"][0]["compte"]
                                                      ["longitude"]);
                                              globals.chaufname =
                                                  result["offres"][0]["compte"]
                                                      ["nom"];
                                              globals.chauffcmtoken =
                                                  result["offres"][0]["compte"]
                                                      ["description"];
                                              globals.chaufprof =
                                                  result["offres"][0]["compte"]
                                                      ["photo"];
                                              globals.chauffeur =
                                                  result["offres"][0]["compte"];
                                              log(result["offres"][0]["compte"]
                                                  ["nom"]);
                                            }
                                          });
                                        }
                                        setState(() {
                                          visible = false;
                                        });
                                      });
                                    },
                                  )
                                : Container()
                          ],
                        ),
                      ),
                      /*   Container(
                          child: GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.radio_button_checked,
                          color: Colors.red,
                          size: 20,
                        ),
                      )),*/
                    )
                  : Container(),
              visible ? Load.loadSubmit(context) : Container(),
              visiblenote
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: new BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                      ),
                      child: Center(
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Opération terminée",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 30.0),
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Text(
                                      "Afin d'optimiser notre plateforme pour mieux vous servir, merci de noter le client",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(50, 25, 50, 25),
                                    child: Row(
                                      children: [
                                        note < 1
                                            ? InkWell(
                                                onTap: () {
                                                  print("ok");

                                                  setState(() {
                                                    note = 1;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoile.png',
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 1;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoilej.png',
                                                  ),
                                                ),
                                              ),
                                        note < 2
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 2;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoile.png',
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 2;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoilej.png',
                                                  ),
                                                ),
                                              ),
                                        note < 3
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 3;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoile.png',
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 3;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoilej.png',
                                                  ),
                                                ),
                                              ),
                                        note < 4
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 4;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoile.png',
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 4;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoilej.png',
                                                  ),
                                                ),
                                              ),
                                        note < 5
                                            ? InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 5;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoile.png',
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    note = 5;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          5 -
                                                      20,
                                                  child: Image.asset(
                                                    'assets/etoilej.png',
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(bottom: 20.0),
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                      note.toString() + "  / 5",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  noteerror
                                      ? Container(
                                          margin: EdgeInsets.only(bottom: 20.0),
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Text(
                                            "Veuillez sélectionner une étoile",
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18,
                                                  color: Colors.red,
                                                ),
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    width: 220,
                                    padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                                    child: RaisedButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onPressed: () async {
                                        if (note > 0) {
                                          setState(() {
                                            visiblenoteload = true;
                                          });

                                          HttpPostRequest.noteChauffeur(
                                                  val == 2
                                                      ? idoffre
                                                      : globals
                                                          .offre["id_offre"],
                                                  val == 2
                                                      ? idc
                                                      : globals
                                                          .offre["commande"],
                                                  note.toString())
                                              .then((String result) async {
                                            setState(() {
                                              visible = false;
                                            });
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            sharedPreferences.setString(
                                                "non_note", "");
                                            log(result);
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          });
                                        } else {
                                          noteerror = true;
                                        }
                                      },
                                      color: MyTheme.button,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              //color: Color.fromRGBO(229, 188, 1, 1),

                                              width: 5,
                                              height: 40,
                                              child: Icon(
                                                Icons.check,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  "Noter",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  visiblenoteload
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text(
                                            AppLocalization.of(context).wait,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    color: MyTheme.primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                          ),
                                        )
                                      : Container(),
                                  visiblenoteload
                                      ? Image.asset('assets/load.gif',
                                          height: 80)
                                      : Container(),
                                ])),
                      ),
                    )
                  : Container(),
              globals.active == "1"
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: new BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                      child: Center(
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "Veuillez Patienter",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 26,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 30.0),
                                    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Text(
                                      "Nous transmettons votre commande au chauffeur le plus proche de vous",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(50, 25, 50, 15),
                                    child: Center(
                                      child: Image.asset('assets/load.gif',
                                          height: 80),
                                    ),
                                  ),
                                  visiblenoteload
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 0.0),
                                          child: Text(
                                            AppLocalization.of(context).wait,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    color: MyTheme.primaryColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 20),
                                          ),
                                        )
                                      : Container(),
                                  Container(
                                    width: 220,
                                    padding: EdgeInsets.fromLTRB(50, 15, 50, 0),
                                    child: RaisedButton(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      onPressed: () async {
                                        setState(() {
                                          visiblenoteload = true;
                                        });
                                        HttpPostRequest.processOperation(
                                                "remove",
                                                globals.idcommande.toString(),
                                                "")
                                            .then((String result) async {
                                          print("quellll rsultttt");
                                          print(result);

                                          setState(() {
                                            visiblenoteload = false;
                                          });
                                          if (result == "null") {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomeScreen()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }

                                          // createMarker(context, value.latitude, value.longitude);
                                        });
                                      },
                                      color: MyTheme.button,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        ),
                                      ),
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 0, 0),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              //color: Color.fromRGBO(229, 188, 1, 1),

                                              width: 5,
                                              height: 40,
                                              child: Icon(
                                                Icons.cancel,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  AppLocalization.of(context)
                                                      .cancel,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black,
                                                      fontSize: 20.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ])),
                      ),
                    )
                  : Container()
            ],
          ),

          //Button zone
        ],
      ),
    );
    _calculateDistance("a");
  }

  String validateMessach(String value) {
// Indian Mobile number are of 10 digit only
    log("eee");
    if (value == "")
      return AppLocalization.of(context).aboutApp;
    else
      return null;
  }

  Widget _wrapWithStuff(Widget child) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Container(
          height: 40.0,
          color: Color.fromRGBO(250, 250, 250, 0.6),
          child: child),
    );
  }
}

Widget getButton() {
  return null;
}

class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inHours.remainder(24).toString()} : ${clockTimer.inMinutes.remainder(60).toString()} : ${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
/*
    print('animation.value  ${animation.value} ');
    print('inMinutes ${clockTimer.inMinutes.toString()}');
    print('inSeconds ${clockTimer.inSeconds.toString()}');
    print(
        'inSeconds.remainder ${clockTimer.inSeconds.remainder(60).toString()}');
*/
    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 30,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
