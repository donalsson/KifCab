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
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                color: MyTheme.stripColor,
                child: Center(
                  // Center is a layout widget. It takes a single child and positions it
                  // in the middle of the parent.
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Row(children: <Widget>[
                        SizedBox(
                          width: 20,
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
                          width: 20,
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(child: Container(

              )),
              Expanded(child: Container(


              ))
            ],
          )
        ],
      ),
    );
  }
}
