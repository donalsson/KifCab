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

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:kifcab/widgets/card_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kifcab/library/loader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:kifcab/screens/location_screen.dart';

import 'package:kifcab/screens/deforevalid.dart';
import 'package:kifcab/utils/tcheckconnection.dart';
import 'package:intl/intl.dart';

import 'package:kifcab/core/httpreq.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
const kGoogleApiKey = "AIzaSyDRn0mlxRwnXRJZI4cNqFOgsGNssI5APRo";

class LocationCarScreen extends StatefulWidget {
  double longitude, latitude;

  LocationCarScreen({
    this.longitude,
    this.latitude,
    Key key,
  }) : super(key: key);

  @override
  _LocationCarScreenState createState() => _LocationCarScreenState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();
String departName;
double deplat;
double deln;

String gammes = globals.locagammes[0].idgamme;
String arrivName;
double arriplat;
double arriln;
DateTime debu, fin;

class _LocationCarScreenState extends State<LocationCarScreen> {
  // DepotScreenState();
  bool _autoValidate = false;
  int _selectedRange = 0;
  int _selectedPayment = 0;
  int _timess = 0;
  int prix = 0;
  double distance;

  bool visible = false;
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
  List<CourseDuration> _durations = [CourseDuration.fill(id: "", name: "")];
  List<CourseDuration> buildDurationList(BuildContext context) {
    List<CourseDuration> durations = [];
    durations.add(CourseDuration.fill(
        id: "", name: AppLocalization.of(context).selectADuration));
    for (int i = 1; i <= 12; i++) {
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
                                              .moreThan100CarAvailabled,
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
                                          AppLocalization.of(context).leaseACar,
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
                                  Icons.directions_bus,
                                  color: Color(0xFAFFFFFF),
                                  size: 40,
                                ),
                                SizedBox(
                                  width: 20,
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
                                  AppLocalization.of(context).startingDate,
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
                            FormBuilderDateTimePicker(
                              //controller: _textControllerTo,
                              //cursorColor: MyTheme.primaryColor,
                              //validator: validatearr,
                              inputType: InputType.both,

                              cursorColor: MyTheme.primaryColor,
                              locale: Locale('fr', "FR"),
                              onChanged: (value) {
                                setState(() {
                                  //  debu = value;
                                  // print(debu.toString());
                                });
                              },
                              validator: validatedated,
                              //initialValue: _durations!=null && _durations.length>0? _durations.elementAt(0):null ,
                              //format: DateFormat('yyyy/MM/dd hh:mm:ss'),
                              style: TextStyle(
                                  color: MyTheme.navBar,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: MyTheme.navBar,
                                    size: 18,
                                  ),
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
                                  hintText:
                                      AppLocalization.of(context).selectADate,
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
                                  AppLocalization.of(context).endingPoint,
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
                            FormBuilderDateTimePicker(
                              inputType: InputType.both,
                              validator: validatedatefin,
                              cursorColor: MyTheme.primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  fin = value;
                                });
                              },
                              locale: Locale('fr', "FR"),
                              style: TextStyle(
                                  color: MyTheme.navBar,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.calendar_today,
                                    color: MyTheme.navBar,
                                    size: 18,
                                  ),
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
                                  hintText:
                                      AppLocalization.of(context).selectADate,
                                  hintStyle: TextStyle(
                                      color: MyTheme.navBar,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 150,
                        //color:Color(0xFFF1F1F1),
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.only(top: 20.0),
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
                                children: loadSubmit10(context, "LOCATION"),
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
                  print(debu.toString());
                  print(DateTime.now().toString());
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    String type = "LOCATION";

                    print(departName);

                    Navigator.of(context).push(PageRouteBuilder(
                        pageBuilder: (_, __, ___) => new Beforevali(
                            type: type,
                            iduser: globals.userinfos.id_compte.toString(),
                            prix: "",
                            depname: departName,
                            arrivname: "",
                            gamme: gammes,
                            depln: deln,
                            deplat: deplat,
                            arrivln: 0,
                            arrivlat: 0,
                            distance: distance.toString(),
                            heure: "",
                            debu: debu,
                            message: "",
                            fin: fin)));

/*
                    HttpPostRequest.saveoperations_request(
                            type,
                            globals.userinfos.id_compte.toString(),
                            "",
                            departName,
                            "",
                            gammes,
                            deln.toString(),
                            deplat.toString(),
                            "",
                            "",
                            "",
                            "",
                            debu.microsecondsSinceEpoch.toString(),
                            fin.microsecondsSinceEpoch.toString())
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
                        // log(result['chauffeur']['description'].toString());
                        /*s globals.commande = result['commande'];
                        globals.chauffeur = result['chauffeur'];
                        globals.type = result['commande']['type'].toString();
                        globals.idcommande =
                            result['commande']['id_commande'].toString();
                        globals.active =
                            result['commande']['active'].toString();*/
                        Fluttertoast.showToast(
                            msg:
                                "Votre Location a été enregistrer avec succès nous vous contaterons Bientot",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green[400],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        /*
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => new MapView(
                                      depname: widget.depname,
                                      deplat: widget.deplat,
                                      depln: widget.depln,
                                      arrivname: widget.arrivname,
                                      arrivlat: widget.arrivlat,
                                      arrivln: widget.arrivln,
                                    )),
                            (Route<dynamic> route) => false);*/
                      }
                    });

                    */
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

  String validatedated(DateTime value) {
    debu = value;
    if (value == null) {
      return "Veuillez renseigner la date de depart";
    } else {
      if (value.millisecondsSinceEpoch <
          DateTime.now().millisecondsSinceEpoch) {
        return "La date depart ne doit etre inferieur a aujoud\'huit";
      } else {
        return null;
      }
    }
  }

  String validatedatefin(DateTime value) {
    fin = value;
    if (debu == null) {
      return "Veuillez renseigner la date de depart";
    } else {
      if (value == null) {
        return "Veuillez renseigner la date de fin";
      } else {
        if (value.millisecondsSinceEpoch < debu.millisecondsSinceEpoch) {
          return "La date fin ne doit etre inferieur a la date de debu";
        } else {
          return null;
        }
      }
    }
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

  List _listings = new List();
  List<Widget> loadSubmit10(context, type) {
    List listings = List<Widget>();
    int i123 = 0;

    for (i123 = 0; i123 < globals.locagammes.length; i123++) {
      // log("i12.5454  " + i123.toString());
      if (i123 == 0) {
        listings.add(
          CardButton(
            index: 0,
            selectedIndex: _selectedRange,
            imageUrl: globals.locagammes[i123].photo,
            isAsset: false,
            text: globals.locagammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                // log(i.toString());
                _selectedRange = 0;
                gammes = globals.locagammes[0].idgamme.toString();
                // prix = (distance + _timess + 1000).round() as int;
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
            imageUrl: globals.locagammes[i123].photo,
            isAsset: false,
            text: globals.locagammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                // log(i.toString());
                _selectedRange = 1;
                gammes = globals.locagammes[1].idgamme.toString();
                // prix = (distance + _timess + 1000).round() as int;
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
            imageUrl: globals.locagammes[i123].photo,
            isAsset: false,
            text: globals.locagammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                //  log(i.toString());
                _selectedRange = 2;
                gammes = globals.locagammes[2].idgamme.toString();
                // prix = (distance + _timess + 1000).round() as int;
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
            imageUrl: globals.locagammes[i123].photo,
            isAsset: false,
            text: globals.locagammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                // log(i.toString());
                _selectedRange = 3;
                gammes = globals.locagammes[3].idgamme.toString();
                // prix = (distance + _timess + 1000).round() as int;
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
            imageUrl: globals.locagammes[i123].photo,
            isAsset: false,
            text: globals.locagammes[i123].libelleg,
            onTap: () {
              print("Tap elemen " + (i123).toString());
              setState(() {
                //  log(i.toString());
                _selectedRange = 4;
                gammes = globals.locagammes[4].idgamme.toString();
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

class CustomSearchScaffold extends PlacesAutocompleteWidget {
  String qualite;
  CustomSearchScaffold({this.qualite})
      : super(
          apiKey: kGoogleApiKey,
          mode: Mode.overlay,
          strictbounds: true,
          location: Uuid().generateLocation(),
          radius: 200000,
          hint: "Entrer le point de départ",
          sessionToken: Uuid().generateV4(),
          language: "fr",
          components: [Component(Component.country, "cmr")],
        );

  @override
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  final DepotScreen = new _LocationCarScreenState();
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
          radius: 200000,
          hint: "Recherche",
          sessionToken: Uuid().generateV4(),
          language: "fr",
          components: [Component(Component.country, "cmr")],
        );

  @override
  _CustomSearchScaffoldState1 createState() => _CustomSearchScaffoldState1();
}

class _CustomSearchScaffoldState1 extends PlacesAutocompleteState {
  final DepotScreen = new _LocationCarScreenState();

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
