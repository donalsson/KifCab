import 'package:flutter/material.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/navigationDrawer/navigation_drawer.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/gestures.dart';

class DepotScreen extends StatefulWidget {
  const DepotScreen({
    Key key,
  }) : super(key: key);

  @override
  DepotScreenState createState() {
    return DepotScreenState();
  }
}

class DepotScreenState extends State<DepotScreen> {
  DepotScreenState();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      drawer: navigationDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(

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
              ),
            ),
          ),




          //Button zone
          Row(
            children: [
              Expanded(
                child: new Container(
                  decoration: BoxDecoration(
                    color: Color(0xFA0c1117),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFA0c1117),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(3, 0), // changes position of shadow
                      ),
                    ],
                    /*boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(3.0, 40.0),
                        blurRadius: 10,
                        spreadRadius: 5.0,
                      ),
                    ],*/
                  ),
                  child: new Material(
                    child: new InkWell(
                      onTap: () {
                        print("tapped");
                      },
                      child: new Container(
                        padding: const EdgeInsets.all(08),
                        child: Column(
                          children: [
                            Icon(
                              Icons.chevron_left,
                              color: Color(0xFAFFFFFF),
                              size: 20,
                            ),
                            Text(AppLocalization.of(context).previous,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white))
                          ],
                        ),
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                ),
              ),
              Expanded(
                child: new Container(
                  decoration: BoxDecoration(
                    color: MyTheme.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: MyTheme.primaryColor,
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(3, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: new Material(
                    child: new InkWell(
                      onTap: () {
                        print("tapped");
                      },
                      child: new Container(
                        padding: const EdgeInsets.all(08),
                        child: Column(
                          children: [
                            Icon(
                              Icons.chevron_right,
                              color: Colors.black,
                              size: 20,
                            ),
                            Text(AppLocalization.of(context).next,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black))
                          ],
                        ),
                      ),
                    ),
                    color: Colors.transparent,
                  ),
                ),
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
