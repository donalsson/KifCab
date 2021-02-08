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
import '../core/global.dart' as globals;
import 'package:kifcab/screens/location_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationScreen extends StatefulWidget {
  String depname, arrivname;
  double depln, deplat, arrivlat, arrivln;

  LocationScreen({
    Key key,
    this.depname,
    this.deplat,
    this.depln,
    this.arrivname,
    this.arrivlat,
    this.arrivln,
  }) : super(key: key);

  @override
  LocationScreenState createState() {
    return LocationScreenState();
  }
}

class LocationScreenState extends State<LocationScreen> {
  LocationScreenState();
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  double distance;
  Position _currentPosition;
  String _currentAddress;
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
  List<LatLng> polylineCoordinates = [];
  int _selectedRange = 0;
  int _selectedPayment = 0;
  int _timess = 0;
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
      color: Colors.red,
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
      drawer: navigationDrawer(),
      body: Column(
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
                  markers: markers != null ? Set<Marker>.from(markers) : null,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(widget.deplat, widget.depln)),
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
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                        child: Text(
                          AppLocalization.of(context).deposit,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 7),
                        child: Text(
                          _placeDistance +
                              " km / " +
                              _timess.toString() +
                              " minutes",
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
                        SizedBox(
                          height: 130,
                          child: TextFormField(
                            minLines: 2,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                                color: MyTheme.navBar,
                                fontWeight: FontWeight.w400),
                            decoration: new InputDecoration(
                                contentPadding: const EdgeInsets.only(
                                    top: 30.0, left: 15, right: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1.2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 1),
                                ),
                                hintText: AppLocalization.of(context)
                                    .messageToSendToTheDriver,
                                hintStyle: TextStyle(
                                    color: MyTheme.navBar,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14)),
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
                                  children: <Widget>[
                                    CardButton(
                                      index: 0,
                                      selectedIndex: _selectedRange,
                                      imageUrl: 'assets/2.png',
                                      isAsset: true,
                                      text: "Classe Bronze",
                                      onTap: () {
                                        print("Tap elemen");
                                        setState(() {
                                          _selectedRange = 0;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CardButton(
                                      index: 1,
                                      selectedIndex: _selectedRange,
                                      imageUrl: 'assets/3.png',
                                      isAsset: true,
                                      text: "Classe Argent",
                                      onTap: () {
                                        print("Tap elemen");
                                        setState(() {
                                          _selectedRange = 1;
                                        });
                                      },
                                    ),
                                  ],
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
                icon: Icons.chevron_right,
                text: AppLocalization.of(context).next,
                onTap: () {
                  print("Valider");
                  // _calculateDistance();
                  /*  mapController.animateCamera(CameraUpdate.newLatLngZoom(
                      LatLng(widget.deplat, widget.depln), 11000.0));*/

                  /*Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => new MapView()));*/
                },
              ),
            ],
          )
        ],
      ),
    );
    _calculateDistance();
  }
}

Widget getButton() {
  return null;
}
