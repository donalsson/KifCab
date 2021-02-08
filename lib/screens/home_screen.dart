import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/navigationDrawer/navigation_drawer.dart';
import 'package:kifcab/utils/Utils.dart';

import 'package:geolocator/geolocator.dart';
import '../core/global.dart' as globals;
import 'package:kifcab/screens/depot_screen.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/gestures.dart';

import 'package:kifcab/utils/tcheckconnection.dart';
import 'package:kifcab/utils/getandsendpossition.dart';

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

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    initSaveData();
    super.initState();
  }

  void initSaveData() async {
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
    techkconnection(context);
    getandsendposition(context);
    return Scaffold(
      backgroundColor: MyTheme.navBar,
      appBar: AppBar(
        elevation: 0.0,
        bottomOpacity: 0.0,
        backgroundColor: MyTheme.navBar,
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
      drawer: navigationDrawer(),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          color: MyTheme.navBar,
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
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
          ),
        ),
      ),
    );
  }
}
