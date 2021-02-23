import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/utils/Utils.dart';

import 'package:geolocator/geolocator.dart';
import '../core/global.dart' as globals;
import 'package:kifcab/screens/depot_screen.dart';
import 'package:kifcab/screens/mapview.dart';
import 'package:kifcab/utils/colors.dart';

import 'package:kifcab/core/httpreq.dart';
import 'package:kifcab/library/loader.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:kifcab/utils/tcheckconnection.dart';
import 'package:kifcab/utils/getandsendpossition.dart';
import 'package:kifcab/utils/tcheckifoperation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

double longitude;
double latitude;
double i = 0;

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();
  final _formKey = GlobalKey<FormBuilderState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool visible = false;
  @override
  void initState() {
    initSaveData();
    super.initState();
  }

  void initSaveData() async {
    HttpPostRequest.getCurrentOperation(globals.userinfos.id_compte)
        .then((dynamic result) async {
      String arr;
      print(result);
      if (result.toString() != "null") {
        setState(() {
          int deparIndex = result["commande"]["depart"].indexOf(',');
          depart = result["commande"]["depart"].substring(0, deparIndex);
          if (result["commande"]["type"] == "RESERVATION") {
            int arrivIndex = result["commande"]["arrive"].indexOf(',');
            arrive = result["commande"]["arrive"].substring(0, arrivIndex);
            arr = result["commande"]["arrive"];
          } else {
            arr = "a";
          }
          globals.commande = result["commande"];
          globals.idcommande = result["commande"]["id_commande"];
          globals.active = result["commande"]["statut"];
          globals.type = result["commande"]["type"];
          if (result["offres"].toString() != "[]") {
            globals.offre = result["offres"][0];

            log("goood");
            globals.chauflat =
                double.parse(result["offres"][0]["compte"]["latitude"]);
            globals.chaufln =
                double.parse(result["offres"][0]["compte"]["longitude"]);
            globals.chaufname = result["offres"][0]["compte"]["nom"];
            globals.chauffcmtoken =
                result["offres"][0]["compte"]["description"];
            globals.chaufprof = result["offres"][0]["compte"]["photo"];
            globals.chauffeur = result["offres"][0]["compte"];
            log(result["offres"][0]["compte"]["nom"]);
          }
          /*   globals.chauffeur = result;
            globals.idcommande = result["commande"]["id_commande"].toString();
            globals.active = result["commande"]["statut"].toString();
            globals.clientfcmtoken = result["client"]["description"].toString();
            globals.clientname = result["client"]["nom"].toString();
            globals.clienttel = result["client"]["telephone"].toString();
            globals.clientprof = result["client"]["photo"].toString();
            globals.clientlat = double.parse(result["client"]["latitude"]);
            globals.clientln = double.parse(result["client"]["longitude"]);*/
        });

        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new MapView(
                  depname: result["commande"]["depart"],
                  deplat: double.parse(result["commande"]["lat_d"]),
                  depln: double.parse(result["commande"]["long_d"]),
                  arrivname: arr,
                  arrivlat: double.parse(result["commande"]["lat_a"]),
                  arrivln: double.parse(result["commande"]["long_a"]),
                )));
      }
      /* if (result.toString() == "[]") {
        print("not current operation");
      } else {
        print("nnok");
        print(result[0]["arrive"].toString());
        globals.type = result[0]["type"];
        globals.active = "1";
        globals.idcommande = result[0]["id_commande"].toString();
        setState(() {
          visible = true;
        });

        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new MapView(
                  depname: result[0]["depart"],
                  deplat: double.parse(result[0]["lat_d"]),
                  depln: double.parse(result[0]["long_d"]),
                  arrivname: result[0]["arrive"],
                  arrivlat: double.parse(result[0]["lat_a"]),
                  arrivln: double.parse(result[0]["long_a"]),
                )));
      }*/
    });

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (i == 0) {
      techkconnection(context);
      getandsendposition(context);
    }
    i = i + 1;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyTheme.navBar,
      appBar: PreferredSize(
        child: Container(
          color: Colors.transparent,
          // color: MyTheme.primaryDarkColor,
        ),
        preferredSize: Size(0.0, 0.0),
      ),
      drawer: navigationDrawer(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          color: MyTheme.navBar,
          child: Stack(children: <Widget>[
            Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (_scaffoldKey.currentState.isDrawerOpen) {
                            _scaffoldKey.currentState.openEndDrawer();
                          } else {
                            _scaffoldKey.currentState.openDrawer();
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.only(top: 15.0, left: 15.0),
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 30.0,
                            ))),
                    InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/welcome',
                              arguments: <String, dynamic>{});
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width - 70,
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(top: 15.0, left: 15.0),
                            child: GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.radio_button_checked,
                                color: Colors.red,
                                size: 20,
                              ),
                            ))),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset(
                  "assets/pages-logo-light.png",
                  width: 130,
                  height: 75,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(AppLocalization.of(context).chooseOfCommandType,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                        color: Colors.white70)),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 0, bottom: 0),
                      child: RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          /*  Navigator.pushReplacementNamed(context, '/depot',
                              arguments: <String, dynamic>{});*/
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new DepotScreen(
                                    longitude: longitude,
                                    latitude: latitude,
                                  )));
                        },
                        color: MyTheme.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                //color: Color.fromRGBO(229, 188, 1, 1),
                                color: Color.fromRGBO(208, 171, 4, 1),
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.local_taxi,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    AppLocalization.of(context).deposit,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 0, bottom: 0),
                      child: RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/course',
                              arguments: <String, dynamic>{});
                        },
                        color: MyTheme.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                //color: Color.fromRGBO(229, 188, 1, 1),
                                color: Color.fromRGBO(208, 171, 4, 1),
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.local_taxi,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    AppLocalization.of(context).course,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 0, bottom: 0),
                      child: RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/location',
                              arguments: <String, dynamic>{});
                        },
                        color: MyTheme.button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.0),
                          ),
                        ),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                //color: Color.fromRGBO(229, 188, 1, 1),
                                color: Color.fromRGBO(208, 171, 4, 1),
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.directions_bus,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    AppLocalization.of(context).location,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.black,
                                        fontSize: 16),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ],
            ),
            visible ? Load.loadSubmit(context) : Container()
          ]),
        ),
      ),
    );
  }
}
