import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_button.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/widgets/card_button.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kifcab/library/loader.dart';
import '../core/global.dart' as globals;
import 'package:kifcab/screens/mapview.dart';
import 'package:kifcab/screens/deforevalid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:kifcab/core/httpreq.dart';

class Coursedetai extends StatefulWidget {
  String depname, dure;
  double depln, deplat;

  Coursedetai({Key key, this.depname, this.deplat, this.depln, this.dure})
      : super(key: key);

  @override
  _CoursedetaiState createState() => _CoursedetaiState();
}

class _CoursedetaiState extends State<Coursedetai> {
  _CoursedetaiState();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  double distance;
  Position _currentPosition;
  String _currentAddress;
  String messagech = "";
  int prix = 0;
  String gammes = globals.depogammes[0].idgamme;
  int i = 0;
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _placeDistance = " ";

  Set<Marker> markers = {};
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  List<LatLng> polylineCoordinates = [];
  int _selectedRange = 0;
  int _selectedPayment = 0;
  int _timess = 0;
  bool visible = false;
/*  final _formKey = GlobalKey<FormBuilderState>();
  String _kGoogleApiKey = GOOGLE_API_KEY;
  final TextEditingController _textControllerFrom = new TextEditingController();
  final TextEditingController _textControllerTo = new TextEditingController();
  bool _showClearButtonInputFrom = false;
  bool _showClearButtonInputTo = false;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

 
  int _step = 0;
  Completer<GoogleMapController> _controllerMap = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(globals.latitude, globals.longitude),
    zoom: 14.4746,
  );
  int _selectedRange = 0;
  int _selectedPayment = 0;
*/

  @override
  void initState() {
    visible = true;
    getprice(gammes, widget.dure);
    super.initState();
    //Timer.run(() => _calculateDistance());
  }

  @override
  void dispose() {
    super.dispose();
  }

  getprice(gam, dure) {
    visible = true;
    HttpPostRequest.getpriceoperation("COURSE", gam, "", dure, "")
        .then((int result) async {
      log(result.toString());

      setState(() {
        visible = false;
      });
      if (result == 0) {
      } else {
        setState(() {
          prix = result;
        });
      }

      // createMarker(context, value.latitude, value.longitude);
    });
  }

  _calculateDistance() async {
    // sleep(Duration: 10);
    //  sleep(Duration(seconds: 10));
    try {
      // Retrieving placemarks from addresses
      /*List<Location> startPlacemark = await locationFromAddress(widget.depname);
      List<Location> destinationPlacemark =
          await locationFromAddress(widget.arrivname);*/
      log("enter");
      /*
      if (widget.deplat != null && widget.arrivlat != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates =
            Position(latitude: widget.deplat, longitude: widget.depln);
        Position destinationCoordinates =
            Position(latitude: widget.arrivlat, longitude: widget.arrivln);

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: widget.depname,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: widget.arrivname,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

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
        log("sdsdsd");
        log(polylineCoordinates.length.toString());

        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }
        timed += _coordinateTimess(totalDistance);
        log("fdfdfdf");
        log(_timess.toString());
        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          _timess = timed;
          distance = totalDistance;
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }*/
      return true;
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
      prix = (distance + _timess + 1000).round() as int;
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
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    i = i + 1;
    log(i.toString());
    if (i == 2) {
      _calculateDistance();
    }

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyTheme.stripColor,
        appBar: PreferredSize(
          child: Container(
            color: Colors.transparent,
            // color: MyTheme.primaryDarkColor,
          ),
          preferredSize: Size(0.0, 0.0),
        ),
        drawer: NavigationDrawer(),
        body: Stack(children: <Widget>[
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 260,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: GoogleMap(
                      // myLocationEnabled: true,
                      markers:
                          markers != null ? Set<Marker>.from(markers) : null,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(widget.deplat, widget.depln),
                          zoom: 16),
                      polylines: Set<Polyline>.of(polylines.values),
                      onMapCreated: (GoogleMapController controller) {
                        mapController = controller;
                      },
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      right: 50,
                      child: Row(
                        children: [
                          Container(
                            color: Colors.black,
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 7),
                            child: Text(
                              AppLocalization.of(context).course,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 7),
                            child: Text(
                              widget.dure.toString() +
                                  " Heures / " +
                                  NumberFormat.simpleCurrency(
                                          locale: "fr_FR",
                                          name: "",
                                          decimalDigits: 0)
                                      .format(prix) +
                                  " Fcfa",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          )
                        ],
                      )),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      color: Colors.transparent,
                      height: AppBar().preferredSize.height,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                              size: 20,
                            ),
                          )),
                          Container(
                              child: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.radio_button_checked,
                              color: Colors.red,
                              size: 20,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                  child: Container(
                      color: Colors.white,
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(children: [
                            new Form(
                              key: _formKey,
                              autovalidate: _autoValidate,
                              child: SizedBox(
                                height: 130,
                                child: TextFormField(
                                  minLines: 2,
                                  maxLines: 5,
                                  keyboardType: TextInputType.multiline,
                                  onChanged: (String val) {
                                    setState(() {
                                      messagech = val;
                                    });
                                  },
                                  style: TextStyle(
                                      color: MyTheme.navBar,
                                      fontWeight: FontWeight.w400),
                                  decoration: new InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          top: 30.0, left: 15, right: 10),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(Radius.zero),
                                        borderSide: BorderSide(
                                            color: Colors.transparent,
                                            width: 1),
                                      ),
                                      hintText: AppLocalization.of(context)
                                          .messageToSendToTheDriver,
                                      hintStyle: TextStyle(
                                          color: MyTheme.navBar,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 14)),
                                ),
                              ),
                            ),
                            Container(
                              height: 250,
                              //color:Color(0xFFF1F1F1),
                              padding: EdgeInsets.all(0),
                              child: ContainedTabBarView(
                                tabs: [
                                  Text(AppLocalization.of(context).ranges,
                                      style: TextStyle(
                                          color: MyTheme.navBar,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14)),
                                  Text(AppLocalization.of(context).payment,
                                      style: TextStyle(
                                          color: MyTheme.navBar,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14))
                                ],
                                tabBarProperties: TabBarProperties(
                                    height: 32.0,
                                    indicatorColor: MyTheme.primaryColor,
                                    indicatorWeight: 2.5,
                                    labelColor: Colors.black,
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    unselectedLabelColor: Colors.grey[400]),
                                views: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    color: Colors.transparent,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      children:
                                          loadSubmit10(context, "RESERVATION"),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    color: Colors.transparent,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      children: <Widget>[
                                        CardButton(
                                          index: 0,
                                          selectedIndex: _selectedPayment,
                                          imageUrl: 'assets/cash.png',
                                          isAsset: true,
                                          text: "Cash",
                                          onTap: () {
                                            print("Tap elemen");
                                            setState(() {
                                              _selectedPayment = 0;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CardButton(
                                          index: 1,
                                          selectedIndex: _selectedPayment,
                                          imageUrl: 'assets/om.jpg',
                                          isAsset: true,
                                          text: "Orange",
                                          onTap: () {
                                            print("Tap elemen");
                                            setState(() {
                                              _selectedPayment = 1;
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        CardButton(
                                          index: 2,
                                          selectedIndex: _selectedPayment,
                                          imageUrl: 'assets/mo.jpg',
                                          isAsset: true,
                                          text: "MTN",
                                          onTap: () {
                                            print("Tap elemen");
                                            setState(() {
                                              _selectedPayment = 2;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onChange: (index) => print(index),
                              ),
                            ),
                          ])))),
              //Button zone
              Row(
                children: [
                  NavigationButton(
                    backColor: Color(0xFA0c1117),
                    textColor: Color(0xFAFFFFFF),
                    icon: Icons.chevron_left,
                    text: AppLocalization.of(context).previous,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  NavigationButton(
                    backColor: MyTheme.primaryColor,
                    textColor: Colors.black,
                    icon: Icons.chevron_right_outlined,
                    text: AppLocalization.of(context).next,
                    onTap: () {
                      setState(() {
                        visible = true;
                      });
                      print("Valider");
                      print(gammes);
                      print(messagech);
                      String type = "COURSE";
                      print(globals.userinfos.id_compte);

                      Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder: (_, __, ___) => new Beforevali(
                              type: type,
                              iduser: globals.userinfos.id_compte.toString(),
                              prix: prix.toString(),
                              depname: widget.depname,
                              arrivname: "",
                              gamme: gammes,
                              depln: widget.depln,
                              deplat: widget.deplat,
                              arrivln: 0,
                              arrivlat: 0,
                              distance: distance.toString(),
                              heure: widget.dure,
                              debu: DateTime.now(),
                              message: messagech,
                              fin: DateTime.now())));
                      setState(() {
                        visible = false;
                      });
/*
                        HttpPostRequest.saveoperations_request(
                                type,
                                globals.userinfos.id_compte.toString(),
                                prix.toString(),
                                widget.depname,
                                "",
                                gammes,
                                widget.depln.toString(),
                                widget.deplat.toString(),
                                "",
                                "",
                                distance.toString(),
                                widget.dure,
                                "",
                                "")
                            .then((dynamic result) async {
                          setState(() {
                            visible = false;
                          });
                          print(result['error']);
                          if (result['error'].toString() == "true") {
                            Fluttertoast.showToast(
                                msg:
                                    "Une erreur s'est produite verifier votre connexion",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } else {
                            log(result['chauffeur']['description'].toString());
                            globals.commande = result['commande'];
                            globals.chauffeur = result['chauffeur'];
                            globals.type =
                                result['commande']['type'].toString();
                            globals.idcommande =
                                result['commande']['id_commande'].toString();
                            globals.active =
                                result['commande']['active'].toString();
                            Fluttertoast.showToast(
                                msg:
                                    "Votre Dépot a été enregistrer avec succès",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green[400],
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => new MapView(
                                          depname: widget.depname,
                                          deplat: widget.deplat,
                                          depln: widget.depln,
                                          arrivname: "a",
                                          arrivlat: 0,
                                          arrivln: 0,
                                        )),
                                (Route<dynamic> route) => false);
                          }
                        });

                        */

                      // _calculateDistance();
                      /*  mapController.animateCamera(CameraUpdate.newLatLngZoom(
                      LatLng(widget.deplat, widget.depln), 11000.0));*/

                      /*  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new MapView(
                            depname: widget.depname,
                            deplat: widget.deplat,
                            depln: widget.depln,
                            arrivname: widget.arrivname,
                            arrivlat: widget.arrivlat,
                            arrivln: widget.arrivln,
                          )));*/
                    },
                  ),
                ],
              )
            ],
          ),
          visible ? Load.loadSubmitPrix(context) : Container()
        ]));
    _calculateDistance();
  }

  String validateMessach(String value) {
// Indian Mobile number are of 10 digit only
    log("eee");
    if (value == "")
      return AppLocalization.of(context).checkmessagech;
    else
      return null;
  }

  List _listings = new List();
  List<Widget> loadSubmit10(context, type) {
    List listings = List<Widget>();
    int i123 = 0;

    for (i123 = 0; i123 < globals.coursegammes.length; i123++) {
      log("i12.5454  " + i123.toString());
      if (i123 == 0) {
        listings.add(
          CardButton(
            index: 0,
            selectedIndex: _selectedRange,
            imageUrl: globals.coursegammes[i123].photo,
            isAsset: false,
            text: globals.coursegammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                log(i.toString());
                _selectedRange = 0;

                gammes = globals.coursegammes[0].idgamme.toString();
                getprice(
                    globals.coursegammes[0].idgamme.toString(), widget.dure);
              });
            },
          ),
        );
      }
      if (i123 == 1) {
        listings.add(
          CardButton(
            index: 1,
            selectedIndex: _selectedRange,
            imageUrl: globals.coursegammes[i123].photo,
            isAsset: false,
            text: globals.coursegammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                log(i.toString());
                _selectedRange = 1;
                gammes = globals.coursegammes[1].idgamme.toString();
                getprice(
                    globals.coursegammes[1].idgamme.toString(), widget.dure);
              });
            },
          ),
        );
      }
      if (i123 == 2) {
        listings.add(
          CardButton(
            index: 2,
            selectedIndex: _selectedRange,
            imageUrl: globals.coursegammes[i123].photo,
            isAsset: false,
            text: globals.coursegammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                log(i.toString());
                _selectedRange = 2;
                gammes = globals.coursegammes[2].idgamme.toString();
                getprice(
                    globals.coursegammes[2].idgamme.toString(), widget.dure);
              });
            },
          ),
        );
      }
      if (i123 == 3) {
        listings.add(
          CardButton(
            index: 3,
            selectedIndex: _selectedRange,
            imageUrl: globals.coursegammes[i123].photo,
            isAsset: false,
            text: globals.coursegammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                log(i.toString());
                _selectedRange = 3;
                gammes = globals.coursegammes[3].idgamme.toString();
                getprice(
                    globals.coursegammes[3].idgamme.toString(), widget.dure);
              });
            },
          ),
        );
      }
      if (i123 == 4) {
        listings.add(
          CardButton(
            index: 4,
            selectedIndex: _selectedRange,
            imageUrl: globals.coursegammes[i123].photo,
            isAsset: false,
            text: globals.coursegammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                log(i.toString());
                _selectedRange = 4;
                gammes = globals.coursegammes[4].idgamme.toString();
                getprice(
                    globals.coursegammes[4].idgamme.toString(), widget.dure);
                // prix = (distance + _timess + 1000).round() as int;
              });
            },
          ),
        );
      }
    }
    return listings;
  }
}

Widget getButton() {
  return null;
}
