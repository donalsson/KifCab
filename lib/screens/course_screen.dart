import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_button.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/widgets/card_button.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:google_maps_webservice/src/core.dart';
import 'dart:async';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:developer';

import '../core/global.dart' as globals;


GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
const kGoogleApiKey = GOOGLE_API_KEY;

class CourseScreen extends StatefulWidget {
  double longitude, latitude;
  CourseScreen({
    this.longitude,
    this.latitude,
    Key key,
  }) : super(key: key);

  @override
  CourseScreenState createState() {
    return CourseScreenState();
  }
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();
String departName;
double deplat;
double deln;

String arrivName;
double arriplat;
double arriln;

class CourseScreenState extends State<CourseScreen> {
  CourseScreenState();
  String _kGoogleApiKey = GOOGLE_API_KEY;
  final TextEditingController _textControllerFrom = new TextEditingController();
  final TextEditingController _textControllerTo = new TextEditingController();
  bool _showClearButtonInputFrom = false;
  bool _showClearButtonInputTo = false;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  Location _fromLocation = null;
  Location _toLocation = null;
  final __textFieldFromFocusNode = FocusNode();
  final _textFieldToFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _step = 0;
  Completer<GoogleMapController> _controllerMap = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  int _selectedRange = 0;
  int _selectedPayment = 0;

  Future<void> _goToTheLake() async {
    _controllerMap = Completer();
    CameraPosition _myLkLake = CameraPosition(
        bearing: 0.8334901395799,
        //bearing: 192.8334901395799,
        target: LatLng(_fromLocation.lat, _fromLocation.lng),
        tilt: 0,
        //tilt: 59.440717697143555,
        zoom: 14.4746);
    final GoogleMapController controller = await _controllerMap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myLkLake));
  }

  @override
  void initState() {
    super.initState();
    _textControllerFrom.addListener(() {
      setState(() {
        _showClearButtonInputFrom = _textControllerFrom.text.length > 0;
      });
    });
    _textControllerTo.addListener(() {
      setState(() {
        _showClearButtonInputTo = _textControllerTo.text.length > 0;
      });
    });
  }

  displayPrediction(Prediction p, ScaffoldState scaffold, String types,
      BuildContext context) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      Navigator.pop(context, [p.description.toString(), lng, lat, types]);
      print(types);
      // Navigator.of(context).pop();
      //  scaffold.showSnackBar(
      // SnackBar(content: Text("${p.description} - $lat/$lng")),
      print("${p.description} - $lat/$lng");

      // );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          if (_step == 0)
            Column(
              children: [
                Container(
                  color: MyTheme.stripColor,
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
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: MyTheme.stripColor,
                  ),
                  child: Center(
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(children: <Widget>[
                          SizedBox(
                            width: 25,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(AppLocalization.of(context).needASecureCar,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17,
                                      color: Colors.white,
                                    )),
                                SizedBox(
                                  height: 07,
                                ),
                                Text(AppLocalization.of(context).takeADeposit,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle2
                                        .copyWith(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.local_taxi,
                            color: Color(0xFAFFFFFF),
                            size: 40,
                          ),
                          SizedBox(
                            width: 25,
                          ),
                        ]),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          if (_step == 0)
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),

                      //_step1
                      Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalization.of(context).startingPoint,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyTheme.navBar,
                                  ),
                                ),
                                Text(
                                  AppLocalization.of(context).required,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: MyTheme.navBar,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _textControllerFrom,
                              cursorColor: MyTheme.primaryColor,
                              focusNode: __textFieldFromFocusNode,
                              onTap: () async {
                                if (__textFieldFromFocusNode.canRequestFocus) {
                                  final result = await Navigator.of(context)
                                      .push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                      new CustomSearchScaffold()));

                                  setState(() {
                                    if(result!=null){
                                      print(result[3]);

                                      _textControllerFrom.text = result[0];
                                      departName = result[0];
                                      deln = result[1];
                                      deplat = result[2];
                                      _fromLocation =
                                          Location(result[2], result[1]);
                                    }

                                  });
                                }
                              },
                              autofocus: false,
                              readOnly: true,
                              style: TextStyle(
                                  color: MyTheme.navBar,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.room,
                                    color: MyTheme.navBar,
                                    size: 18,
                                  ),
                                  suffixIcon: _showClearButtonInputFrom
                                      ? IconButton(
                                    onPressed: () {
                                      __textFieldFromFocusNode.unfocus();
                                      __textFieldFromFocusNode
                                          .canRequestFocus = false;
                                      _textControllerFrom.clear();
                                      _fromLocation = null;
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: MyTheme.navBar,
                                      size: 16,
                                    ),
                                  )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.primaryColor,
                                        width: 1.2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.navBar, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.navBar, width: 1),
                                  ),
                                  hintText: AppLocalization.of(context)
                                      .enterTheStartingPoint,
                                  hintStyle: TextStyle(
                                      color: MyTheme.navBar,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14)),
                            ),
                            if (_fromLocation != null)
                              Text(
                                _fromLocation.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: MyTheme.navBar,
                                ),
                              )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalization.of(context).arrivalPoint,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MyTheme.navBar,
                                  ),
                                ),
                                Text(
                                  AppLocalization.of(context).required,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: MyTheme.navBar,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: _textControllerTo,
                              cursorColor: MyTheme.primaryColor,
                              focusNode: _textFieldToFocusNode,
                              onTap: () async {
                                if (_textFieldToFocusNode.canRequestFocus) {
                                  final result = await Navigator.of(context)
                                      .push(PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, __, ___) =>
                                      new CustomSearchScaffold1()));

                                  setState(() {
                                    if(result!=null){
                                      print(result[3]);

                                      _textControllerTo.text = result[0];
                                      departName = result[0];
                                      deln = result[1];
                                      deplat = result[2];
                                      _toLocation =
                                          Location(result[2], result[1]);
                                    }
                                  });
                                }
                              },
                              autofocus: false,
                              readOnly: true,
                              style: TextStyle(
                                  color: MyTheme.navBar,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.room,
                                    color: MyTheme.navBar,
                                    size: 18,
                                  ),
                                  suffixIcon: _showClearButtonInputTo
                                      ? IconButton(
                                    onPressed: () {
                                      _textFieldToFocusNode.unfocus();
                                      _textFieldToFocusNode
                                          .canRequestFocus = false;
                                      _textControllerTo.clear();
                                      _toLocation = null;
                                    },
                                    icon: Icon(
                                      Icons.clear,
                                      color: MyTheme.navBar,
                                      size: 16,
                                    ),
                                  )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.primaryColor,
                                        width: 1.2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.navBar, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.navBar, width: 1),
                                  ),
                                  hintText: AppLocalization.of(context)
                                      .enterTheArrivalPoint,
                                  hintStyle: TextStyle(
                                      color: MyTheme.navBar,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14)),
                            ),
                            if (_toLocation != null)
                              Text(
                                _toLocation.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: MyTheme.navBar,
                                ),
                              )
                          ],
                        ),
                      ),
                      //_step2
                    ],
                  ),
                ),
              ),
            ),

          if (_step == 1)
            Stack(
              children: [
                Container(
                  height: 260,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child:  GoogleMap(
                    // myLocationEnabled: true,
                    compassEnabled: false,

                    initialCameraPosition: _kGooglePlex,

                    onMapCreated: (GoogleMapController controller) {
                      if (!_controllerMap.isCompleted)
                        _controllerMap.complete(controller);
                    },
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 50,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.black,
                          padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          child: Text(
                            AppLocalization.of(context).deposit,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          child: Text(
                            "/",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
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

          if (_step == 1)
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
                                      top: 20.0, left: 15, right: 10),
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
                  if (_step == 0) {
                    Navigator.pushReplacementNamed(context, '/home',
                        arguments: <String, dynamic>{});
                  } else {
                    this.setState(() {
                      _step--;
                    });
                  }
                },
              ),
              NavigationButton(
                backColor: MyTheme.primaryColor,
                textColor: Colors.black,
                icon: (_step == 1) ? Icons.check : Icons.chevron_right,
                text: (_step == 1)
                    ? AppLocalization.of(context).save
                    : AppLocalization.of(context).next,
                onTap: () {
                  if (_step == 1) {
                    print("Valider");
                  } else {
                    _goToTheLake();
                    this.setState(() {
                      _step++;
                    });
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget getButton() {
  return null;
}

class CustomSearchScaffold extends PlacesAutocompleteWidget {
  String qualite;
  CustomSearchScaffold({this.qualite})
      : super(
    apiKey: kGoogleApiKey,
    mode: Mode.overlay,
    strictbounds: true,
    location: Uuid().generateLocation(),
    radius: 20000,
    hint: "Recherchez",
    sessionToken: Uuid().generateV4(),
    language: "fr",
    components: [Component(Component.country, "cmr")],
  );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  final DepotScreen = new CourseScreenState();
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: AppBarPlacesAutoCompleteTextField(),
      backgroundColor: Colors.black54,
    );
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        DepotScreen.displayPrediction(
            p, searchScaffoldKey.currentState, "depart", context);
      },
      logo: Row(),
    );
    return Scaffold(
      key: searchScaffoldKey,
      appBar: appBar,
      body: body,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    /*searchScaffoldKey.currentState.showSnackBar(
        // SnackBar(content: Text(response.errorMessage)),
        );*/
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      /*  searchScaffoldKey.currentState.showSnackBar(
          // SnackBar(content: Text("Got answer")),
          );*/
    }
  }
}

void getLocation() {}

class CustomSearchScaffold1 extends PlacesAutocompleteWidget {
  CustomSearchScaffold1()
      : super(
    apiKey: kGoogleApiKey,
    mode: Mode.overlay,
    strictbounds: true,
    location: Uuid().generateLocation(),
    radius: 20000,
    hint: "Recherche",
    sessionToken: Uuid().generateV4(),
    language: "fr",
    components: [Component(Component.country, "cmr")],
  );

  @override
  _CustomSearchScaffoldState1 createState() => _CustomSearchScaffoldState1();
}

class _CustomSearchScaffoldState1 extends PlacesAutocompleteState {
  final DepotScreen = new CourseScreenState();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: AppBarPlacesAutoCompleteTextField(),
      backgroundColor: Colors.black54,
    );
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        DepotScreen.displayPrediction(
            p, searchScaffoldKey.currentState, "arriver", context);
      },
      logo: Row(),
    );
    return Scaffold(
      key: searchScaffoldKey,
      appBar: appBar,
      body: body,
      backgroundColor: Color.fromRGBO(0, 0, 0, 0.9),
    );
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    /*searchScaffoldKey.currentState.showSnackBar(
        // SnackBar(content: Text(response.errorMessage)),
        );*/
  }

  @override
  void onResponse(PlacesAutocompleteResponse response) {
    super.onResponse(response);
    if (response != null && response.predictions.isNotEmpty) {
      /*  searchScaffoldKey.currentState.showSnackBar(
          // SnackBar(content: Text("Got answer")),
          );*/
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  Location generateLocation() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);
    print(globals.latitude);
    print(globals.longitude);
    return new Location(globals.latitude, globals.longitude);
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
