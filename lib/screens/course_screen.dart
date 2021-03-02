import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart' hide Mode;
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/models/CourseDuration.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:kifcab/widgets/location_input.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import '../core/global.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:kifcab/screens/location_screen.dart';
import 'package:kifcab/screens/coursedet.dart';

import 'package:kifcab/utils/tcheckconnection.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
const kGoogleApiKey = "AIzaSyDRn0mlxRwnXRJZI4cNqFOgsGNssI5APRo";

class CourseScreen extends StatefulWidget {
  double longitude, latitude;

  CourseScreen({
    this.longitude,
    this.latitude,
    Key key,
  }) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();
String departName;
String dure;
double deplat;
double deln;

String arrivName;
double arriplat;
double arriln;

class _CourseScreenState extends State<CourseScreen> {
  // DepotScreenState();
  bool _autoValidate = false;
  Mode _mode = Mode.overlay;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String kGoogleApiKey = GOOGLE_API_KEY;
  final TextEditingController _textControllerFrom = new TextEditingController();
  final TextEditingController _textControllerTo = new TextEditingController();
  bool _showClearButtonInputFrom = false;
  bool _showClearButtonInputTo = false;
  static final kInitialPosition = LatLng(4.024394577478441, 9.705471602732858);
// Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
  );
  List<CourseDuration> _durations = [CourseDuration.fill(id: "", name: "")];
  List<CourseDuration> buildDurationList(BuildContext context) {
    List<CourseDuration> durations = [];
    durations.add(CourseDuration.fill(
        id: "", name: AppLocalization.of(context).selectADuration));
    for (int i = 1; i <= 6; i++) {
      durations.add(CourseDuration.fill(
          id: "1", name: AppLocalization.of(context).durationFor(i)));
    }
    setState(() {
      _durations = durations;
    });
  }

// Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      this.buildDurationList(context);
    });
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

  @override
  void dispose() {
    super.dispose();
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
  Widget build(BuildContext context) {
    /*
    Location location = new Location(widget.longitude, widget.latitude);
    print("widget.latitude");
    print(widget.latitude);
    globals.location = location;

    */

    techkconnection(context);
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
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                decoration: new BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.0),
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Color.fromRGBO(0, 0, 0, 0.1), BlendMode.dstATop),
                    image: AssetImage("assets/pictures/2.jpg"),
                  ),
                ),
                child: Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      AppLocalization.of(context)
                                          .needACarForAPeriod,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16,
                                            color: Colors.white,
                                          )),
                                  SizedBox(
                                    height: 07,
                                  ),
                                  Text(
                                      AppLocalization.of(context)
                                          .makeForCourses,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.white)),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.local_taxi,
                              color: Color(0xFAFFFFFF),
                              size: 40,
                            ),
                          ]),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ),
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

          Form(
            key: _formKey,
            autovalidate: _autoValidate,
            child: Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
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
                            TextFormField(
                              controller: _textControllerFrom,
                              validator: validatedep,
                              cursorColor: MyTheme.primaryColor,
                              onTap: () async {
                                print("depart");
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final result = await Navigator.of(context).push(
                                    PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            new CustomSearchScaffold()));

                                setState(() {
                                  print(result[3]);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _textControllerFrom.text = result[0];
                                  departName = result[0];
                                  deln = result[1];
                                  deplat = result[2];
                                });
                              },
                              onSaved: (String val) {
                                departName = val;
                              },
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
                                          onPressed: () =>
                                              _textControllerFrom.clear(),
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
                                  AppLocalization.of(context).duration,
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
                            if (_durations != null && _durations.length > 0)
                              FormBuilderDropdown(
                                //controller: _textControllerTo,
                                //cursorColor: MyTheme.primaryColor,
                                //validator: validatearr,

                                validator: (value) => value == null
                                    ? 'Veuillez sélectioner la durée'
                                    : null,
                                items: _durations
                                    .map((duration) => DropdownMenuItem(
                                          value: duration.name,
                                          child: Text(
                                            '${duration.name}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2
                                                .copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                  color: Color(0xFF888888),
                                                ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dure = value.toString();
                                  });
                                },
                                onTap: () async {
                                  // print("arriver");
                                },
                                //initialValue: _durations!=null && _durations.length>0? _durations.elementAt(0):null ,

                                style: TextStyle(
                                    color: MyTheme.primaryColor,
                                    fontWeight: FontWeight.w400),
                                decoration: new InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.alarm,
                                      color: MyTheme.navBar,
                                      size: 18,
                                    ),
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: MyTheme.navBar,
                                      size: 22,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 10),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                      borderSide: BorderSide(
                                          color: MyTheme.primaryColor,
                                          width: 1.2),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                      borderSide: BorderSide(
                                          color: MyTheme.navBar, width: 1),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.zero),
                                      borderSide: BorderSide(
                                          color: MyTheme.navBar, width: 1),
                                    ),
                                    hintText: AppLocalization.of(context)
                                        .selectADuration,
                                    hintStyle: TextStyle(
                                        color: MyTheme.navBar,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14)),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          //Button zone
          Row(
            children: [
              NavigationButton(
                backColor: Color(0xFA0c1117),
                textColor: Color(0xFAFFFFFF),
                icon: Icons.chevron_left,
                text: AppLocalization.of(context).previous,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home',
                      arguments: <String, dynamic>{});
                },
              ),
              NavigationButton(
                backColor: MyTheme.primaryColor,
                textColor: Colors.black,
                icon: Icons.chevron_right,
                text: AppLocalization.of(context).next,
                onTap: () {
                  print("tapped next");
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    print(departName);
                    //  print(duration.toString());

                    dure = dure.substring(5, 6);
                    print(dure);
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new Coursedetai(
                              depname: departName,
                              deplat: deplat,
                              depln: deln,
                              dure: dure,
                            )));
                  } else {
                    setState(() {
                      _autoValidate = true;
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

  String validatedep(String value) {
    departName = value;
    if (value.length < 3)
      return AppLocalization.of(context).valenterTheStartingPoint;
    else
      return null;
  }

  String validatearr(String value) {
    arrivName = value;
    if (value.length < 3)
      return AppLocalization.of(context).valenterTheArrivalPoint;
    else
      return null;
  }
}

class CustomSearchScaffold extends PlacesAutocompleteWidget {
  String qualite;
  CustomSearchScaffold({this.qualite})
      : super(
          apiKey: kGoogleApiKey,
          mode: Mode.overlay,
          strictbounds: true,
          location: Uuid().generateLocation(),
          radius: 200,
          hint: "Entrer le point de départ",
          sessionToken: Uuid().generateV4(),
          language: "fr",
          components: [Component(Component.country, "cmr")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  final DepotScreen = new _CourseScreenState();
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: AppBarPlacesAutoCompleteTextField(),
      backgroundColor: Colors.white10,
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
  final DepotScreen = new _CourseScreenState();

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
    return new Location(globals.latitude, globals.longitude);
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}

Widget getButton() {
  return null;
}
