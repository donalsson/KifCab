import 'package:flutter/material.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/gestures.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({
    Key key,
  }) : super(key: key);

  @override
  WelcomeScreenState createState() {
    return WelcomeScreenState();
  }
}

class WelcomeScreenState extends State<WelcomeScreen> {
  WelcomeScreenState();
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
      backgroundColor: MyTheme.navBar,
      /*appBar: AppBar(
        leading: GestureDetector(onTap: () {}, child: Icon(Icons.arrow_back)),
        elevation: 0.0,
        bottomOpacity: 0.0,
        backgroundColor: MyTheme.navBar,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 15.0),
              child: GestureDetector(
                onTap: () {},
                child: Text(
                  "En",
                  style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 18),
                ),
              )),
        ],
      ),*/
      appBar: PreferredSize(
        child: Container(
          color: Colors.transparent,
          // color: MyTheme.primaryDarkColor,
        ),
        preferredSize: Size(0.0, 0.0),
      ),
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
                  height: 130,
                ),
                Image.asset(
                  "assets/pages-logo-light2.png",
                  width: 150,
                  height: 100,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(AppLocalization.of(context).welcomeMessage,
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.white)),
                SizedBox(
                  height: 65,
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
                          Navigator.pushReplacementNamed(context, '/login',
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
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.black,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    AppLocalization.of(context).login,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
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
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 0, bottom: 0),
                      child: RaisedButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register',
                              arguments: <String, dynamic>{});
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(0.0),
                            ),
                            side: BorderSide(color: MyTheme.button, width: 2)),
                        color: MyTheme.background,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                //color: Color.fromRGBO(229, 188, 1, 1),
                                color: Color.fromRGBO(40, 39, 44, 1),
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.add,
                                  color: MyTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    AppLocalization.of(context).createAnAccount,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: MyTheme.primaryColor,
                                    ),
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
                Container(
                  padding: const EdgeInsets.only(left: 70, right: 30),
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalization.of(context).changeLanguage("En"),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => AppLocalization.load(new Locale("en")),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: MyTheme.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
