import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:kifcab/widgets/location_input.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import '../core/global.dart' as globals;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:kifcab/screens/location_screen.dart';

import 'package:kifcab/utils/tcheckconnection.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
const kGoogleApiKey = "AIzaSyDRn0mlxRwnXRJZI4cNqFOgsGNssI5APRo";

class DepotScreen extends StatefulWidget {
  double longitude, latitude;

  DepotScreen({
    this.longitude,
    this.latitude,
    Key key,
  }) : super(key: key);

  @override
  _DepotScreenState createState() => _DepotScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();
String departName;
double deplat;
double deln;

String arrivName;
double arriplat;
double arriln;

class _DepotScreenState extends State<DepotScreen> {
  // DepotScreenState();
  bool _autoValidate = false;
  Mode _mode = Mode.overlay;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
      backgroundColor: MyTheme.stripColor,
      appBar: AppBar(
        elevation: 0.0,
        bottomOpacity: 0.0,
        backgroundColor: MyTheme.stripColor,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 15.0),
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
      drawer: NavigationDrawer(),
      body: Column(
        children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppLocalization.of(context)
                                              .needASecureCar,
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
                                      Text(
                                          AppLocalization.of(context)
                                              .takeADeposit,
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
                                /* Navigator.of(context).push(PageRouteBuilder(
                                    opaque: false,
                                    pageBuilder: (_, __, ___) =>
                                        new CustomSearchScaffold()));*/
/*
                                Prediction p = await PlacesAutocomplete.show(
                                    context: context,
                                    apiKey: kGoogleApiKey,
                                    mode: Mode.overlay, // Mode.fullscreen
                                    language: "fr",
                                    components: [
                                      new Component(Component.country, "fr")
                                    ]);
*/
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final result = await Navigator.of(context).push(
                                    PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            new CustomSearchScaffold()));

                                setState(() {
                                  print(result[3]);

                                  _textControllerFrom.text = result[0];
                                  departName = result[0];
                                  deln = result[1];
                                  deplat = result[2];

                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                });
                                /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                      apiKey:
                                          kGoogleApiKey, // Put YOUR OWN KEY here.
                                      onPlacePicked: (result) {
                                        _textControllerFrom.text = result
                                                .addressComponents[0].longName +
                                            ", " +
                                            result
                                                .addressComponents[1].longName +
                                            ", " +
                                            result
                                                .addressComponents[2].longName;
                                        deplat = result.geometry.location.lat;
                                        deln = result.geometry.location.lng;
                                        departName = result
                                                .addressComponents[0].longName +
                                            ", " +
                                            result
                                                .addressComponents[1].longName +
                                            ", " +
                                            result
                                                .addressComponents[2].longName;
                                        print(result.name.toString());
                                        print(jsonDecode(result.toString()));
                                        print(result
                                                .addressComponents[0].longName +
                                            ", " +
                                            result
                                                .addressComponents[1].longName +
                                            ", " +
                                            result
                                                .addressComponents[2].longName);
                                        Navigator.of(context).pop();
                                      },
                                      strictbounds: true,
                                      useCurrentLocation: true,
                                      initialPosition: kInitialPosition,
                                      selectInitialPosition: true,
                                      initialMapType: MapType.terrain,
                                    ),
                                  ),
                                );*/
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
                            TextFormField(
                              controller: _textControllerTo,
                              cursorColor: MyTheme.primaryColor,
                              validator: validatearr,
                              onTap: () async {
                                print("arriver");
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                final result = await Navigator.of(context).push(
                                    PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, __, ___) =>
                                            new CustomSearchScaffold1()));
                                setState(() {
                                  print(result[3]);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  _textControllerTo.text = result[0];
                                  arrivName = result[0];
                                  arriln = result[1];
                                  arriplat = result[2];
                                });

                                /*  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PlacePicker(
                                      apiKey:
                                          kGoogleApiKey, // Put YOUR OWN KEY here.
                                      onPlacePicked: (result) {
                                        _textControllerTo.text = result
                                                .addressComponents[0].longName +
                                            ", " +
                                            result
                                                .addressComponents[1].longName +
                                            ", " +
                                            result
                                                .addressComponents[2].longName;
                                        arriplat = result.geometry.location.lat;
                                        arriln = result.geometry.location.lng;
                                        arrivName = result
                                                .addressComponents[0].longName +
                                            ", " +
                                            result
                                                .addressComponents[1].longName +
                                            ", " +
                                            result
                                                .addressComponents[2].longName;
                                        print(result
                                                .addressComponents[0].longName +
                                            ", " +
                                            result
                                                .addressComponents[1].longName +
                                            ", " +
                                            result
                                                .addressComponents[2].longName);
                                        Navigator.of(context).pop();
                                      },
                                      useCurrentLocation: true,
                                      initialPosition: kInitialPosition,
                                      forceAndroidLocationManager: true,
                                      selectInitialPosition: false,
                                      initialMapType: MapType.hybrid,
                                      autocompleteRadius: 200,
                                      autocompleteLanguage: "fr",
                                      searchingText: "dsdsd",
                                    ),
                                  ),
                                );*/
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
                                  suffixIcon: _showClearButtonInputTo
                                      ? IconButton(
                                          onPressed: () =>
                                              _textControllerTo.clear(),
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
                  Navigator.pop(context);
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
                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new LocationScreen(
                              depname: departName,
                              deplat: deplat,
                              depln: deln,
                              arrivname: arrivName,
                              arrivlat: arriplat,
                              arrivln: arriln,
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
  final DepotScreen = new _DepotScreenState();
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
          hint: "Entrer le point d'arriver",
          sessionToken: Uuid().generateV4(),
          language: "fr",
          components: [Component(Component.country, "cmr")],
        );

  @override
  _CustomSearchScaffoldState1 createState() => _CustomSearchScaffoldState1();
}

class _CustomSearchScaffoldState1 extends PlacesAutocompleteState {
  final DepotScreen = new _DepotScreenState();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: AppBarPlacesAutoCompleteTextField(),
      backgroundColor: Colors.white10,
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
