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
import 'package:kifcab/screens/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:kifcab/core/httpreq.dart';

class Beforevali extends StatefulWidget {
  String depname,
      arrivname,
      gamme,
      distance,
      heure,
      prix,
      iduser,
      message,
      type;
  DateTime debu, fin;
  double depln, deplat, arrivlat, arrivln;
  Beforevali({
    Key key,
    this.depname,
    this.deplat,
    this.depln,
    this.arrivname,
    this.arrivlat,
    this.arrivln,
    this.type,
    this.iduser,
    this.prix,
    this.gamme,
    this.distance,
    this.debu,
    this.fin,
    this.heure,
    this.message,
  }) : super(key: key);

  @override
  _BeforevaliState createState() => _BeforevaliState();
}

class _BeforevaliState extends State<Beforevali> {
  _BeforevaliState();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  double distance;
  Position _currentPosition;
  String _currentAddress;
  String messagech, depart, arrive = "";
  int prix = 0;
  String gammes = "Bronse";
  int i = 0;
  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();
  Timer _timer;
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
  Locale locale;
  var format;
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
    super.initState();

    //Timer.run(() => _calculateDistance());
  }

  @override
  void dispose() {
    super.dispose();
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
    if (i == 1 && widget.type == "RESERVATION") {
      const oneSec = const Duration(seconds: 2);
      _timer = new Timer.periodic(oneSec, (Timer timer) async {
        _calculateDistance();
        _timer.cancel();
      });
    }

    int deparIndex = widget.depname.indexOf(',');
    depart = widget.depname.substring(0, deparIndex);
    if (widget.arrivname != "") {
      log("widget.arrivname");
      log(widget.arrivname);
      int arrivIndex = widget.arrivname.indexOf(',');
      arrive = widget.arrivname.substring(0, arrivIndex);
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
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(children: [
                            widget.type == "RESERVATION"
                                ? Container(
                                    color: MyTheme.primaryColor,
                                    padding: EdgeInsets.all(10.0),
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      "DEPOT POUR " + arrive.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )),
                                  )
                                : Container(),
                            widget.type == "COURSE"
                                ? Container(
                                    color: MyTheme.primaryColor,
                                    padding: EdgeInsets.all(10.0),
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      widget.type.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )),
                                  )
                                : Container(),
                            widget.type == "LOCATION"
                                ? Container(
                                    color: MyTheme.primaryColor,
                                    padding: EdgeInsets.all(10.0),
                                    width: MediaQuery.of(context).size.width,
                                    child: Center(
                                        child: Text(
                                      widget.type.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )),
                                  )
                                : Container(),
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Information de commande',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        color: MyTheme.navBar,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              48,
                                          child: RichText(
                                            text: new TextSpan(
                                              // Note: Styles for TextSpans must be explicitly defined.
                                              // Child text spans will inherit styles from parent
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 14,
                                                      color: Colors.black),
                                              children: <TextSpan>[
                                                new TextSpan(
                                                    text: "Départ :   ",
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                new TextSpan(
                                                  text: depart,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black45,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  widget.type == "RESERVATION"
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: MyTheme.navBar,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    48,
                                                child: RichText(
                                                  text: new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                              "Destination :   ",
                                                          style: new TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      new TextSpan(
                                                        text: arrive,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        )
                                      : Container(),
                                  widget.type == "COURSE"
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              color: MyTheme.navBar,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    48,
                                                child: RichText(
                                                  text: new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text: "Durée :   ",
                                                          style: new TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      new TextSpan(
                                                        text: widget.heure,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        )
                                      : Container(),
                                  widget.type == "LOCATION"
                                      ? Row(
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              color: MyTheme.navBar,
                                              size: 18,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    48,
                                                child: RichText(
                                                  text: new TextSpan(
                                                    // Note: Styles for TextSpans must be explicitly defined.
                                                    // Child text spans will inherit styles from parent
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                    children: <TextSpan>[
                                                      new TextSpan(
                                                          text:
                                                              "Date Début :   ",
                                                          style: new TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      new TextSpan(
                                                        text: DateFormat(
                                                                'dd-MM-yyyy  à  kk:mm')
                                                            .format(
                                                                widget.debu),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black45,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: MyTheme.navBar,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      widget.type == "RESERVATION" ||
                                              widget.type == "COURSE"
                                          ? Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  48,
                                              child: RichText(
                                                text: new TextSpan(
                                                  // Note: Styles for TextSpans must be explicitly defined.
                                                  // Child text spans will inherit styles from parent
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: "Date :   ",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    new TextSpan(
                                                      text: DateFormat(
                                                              'dd-MM-yyyy  à  kk:mm')
                                                          .format(
                                                              DateTime.now()),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          : Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  48,
                                              child: RichText(
                                                text: new TextSpan(
                                                  // Note: Styles for TextSpans must be explicitly defined.
                                                  // Child text spans will inherit styles from parent
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                  children: <TextSpan>[
                                                    new TextSpan(
                                                        text: "Date Fin :  ",
                                                        style: new TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    new TextSpan(
                                                      text: DateFormat(
                                                              'dd-MM-yyyy  à  kk:mm')
                                                          .format(widget.fin),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black45,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                    ],
                                  ),
                                  widget.type == "RESERVATION" ||
                                          widget.type == "COURSE"
                                      ? Container(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.mail,
                                                    color: MyTheme.navBar,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              48,
                                                      child: RichText(
                                                        text: new TextSpan(
                                                          // Note: Styles for TextSpans must be explicitly defined.
                                                          // Child text spans will inherit styles from parent
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyText1
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                          children: <TextSpan>[
                                                            new TextSpan(
                                                                text:
                                                                    "Message :   ",
                                                                style: new TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            new TextSpan(
                                                              text: widget
                                                                  .message,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black45,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ))
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(color: Colors.black),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: 200,
                              child: Center(
                                child: RaisedButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onPressed: () async {},
                                  color: MyTheme.button,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          //color: Color.fromRGBO(229, 188, 1, 1),

                                          width: 40,
                                          height: 25,
                                          child: Text(
                                            "Prix :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                                fontSize: 17.0),
                                          ),
                                        ),
                                        Expanded(
                                          child: Center(
                                            child: Text(
                                              NumberFormat.simpleCurrency(
                                                          locale: "fr_FR",
                                                          name: "",
                                                          decimalDigits: 0)
                                                      .format(int.parse(
                                                          widget.prix)) +
                                                  " Fcfa",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 17.0),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ])))),
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
                    backColor: MyTheme.button,
                    textColor: Colors.black,
                    icon: Icons.check,
                    text: "Valider",
                    onTap: () {
                      setState(() {
                        visible = true;
                      });

                      HttpPostRequest.saveoperations_request(
                              widget.type,
                              globals.userinfos.id_compte.toString(),
                              widget.prix,
                              widget.depname,
                              widget.arrivname,
                              widget.gamme,
                              widget.depln.toString(),
                              widget.deplat.toString(),
                              widget.arrivln.toString(),
                              widget.arrivlat.toString(),
                              distance.toString(),
                              widget.heure,
                              widget.debu.toString(),
                              widget.fin.toString(),
                              widget.message.toString())
                          .then((dynamic result) async {
                        setState(() {
                          visible = false;
                        });
                        print(result);
                        print(result);
                        if (result == "error") {
                          return showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: Colors.white,
                              content: Text(
                                "Tous les chauffeurs de cette gamme ne sont pas disponibles; veuillez réessayer dans quelques minutes ou changer de gamme.",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
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
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    "Ok",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
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
                          globals.commande = result['commande'];
                          globals.chauffeur = result['chauffeur'];
                          globals.type = result['commande']['type'].toString();
                          globals.idcommande =
                              result['commande']['id_commande'].toString();
                          globals.active =
                              result['commande']['active'].toString();
                          /* Fluttertoast.showToast(
                              msg: "Votre " +
                                  widget.type +
                                  " a été enregistrer avec succès",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green[400],
                              textColor: Colors.white,
                              fontSize: 16.0);*/
                          if (widget.type != "LOCATION") {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => new MapView(
                                          depname: widget.depname,
                                          prixt: int.parse(widget.prix),
                                          deplat: widget.deplat,
                                          depln: widget.depln,
                                          arrivname: widget.arrivname,
                                          arrivlat: widget.arrivlat,
                                          arrivln: widget.arrivln,
                                        )),
                                (Route<dynamic> route) => false);
                          } else {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => new HomeScreen()),
                                (Route<dynamic> route) => false);
                          }
                        }
                      });
                    },
                  ),
                ],
              )
              //Button zone
              /*   Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: NavigationButton(
                      backColor: Color(0xFA0c1117),
                      textColor: Color(0xFAFFFFFF),
                      icon: Icons.chevron_left,
                      text: AppLocalization.of(context).previous,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: NavigationButton(
                      backColor: Color.fromRGBO(191, 191, 191, 1),
                      textColor: Colors.black,
                      icon: Icons.cancel_outlined,
                      text: AppLocalization.of(context).cancel,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              )*/
            ],
          ),
          visible ? Load.loadSubmit(context) : Container()
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
}

Widget getButton() {
  return null;
}
