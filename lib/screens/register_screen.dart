import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:math';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter/material.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:kifcab/core/httpreq.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kifcab/library/loader.dart';

import 'package:kifcab/utils/tcheckconnection.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key key,
  }) : super(key: key);

  @override
  RegisterScreenState createState() {
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  RegisterScreenState();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String nom;
  String email;
  String ville;
  Timer _timer;
  int code;
  int code0;
  String phoneIsoCode;
  String _name;
  var texttt = TextEditingController();
  SmsQuery query = new SmsQuery();
  bool _autoValidate = false;
  bool visible = false;
  String telephone;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initPlatformState(code) async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    const oneSec = const Duration(seconds: 5);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () async {
          var list = await query.querySms(address: "KifCab");
          var i = 0;
          print("list");
          while (i < list.length) {
            print(list[i].body);
            print(code);

            var string = list[i].body;
            var resul = string.split(": ");
            print(resul[1]);
            if (resul[1].toString() == code.toString()) {
              print('arret');
              texttt.text = code.toString();
              _timer.cancel();
              _validateInputs10();
            }

            i = i + 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    techkconnection(context);
    return Scaffold(
      backgroundColor: MyTheme.navBar,
      /*   appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/welcome',
                  arguments: <String, dynamic>{});
            },
            child: Icon(Icons.arrow_back)),
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
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
              )),
        ],
      ),*/
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          color: MyTheme.navBar,
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
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
                            Navigator.pushReplacementNamed(context, '/welcome',
                                arguments: <String, dynamic>{});
                          },
                          child: Padding(
                              padding: EdgeInsets.only(top: 35.0, left: 15.0),
                              child: Icon(
                                Icons.arrow_back,
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
                              padding: EdgeInsets.only(top: 35.0, left: 15.0),
                              child: Text(
                                "En",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                              ))),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/login.png"),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Form(
                      key: _formKey,
                      autovalidate: _autoValidate,
                      child: Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: Utils.getInputDecoration(
                                  AppLocalization.of(context).hintName,
                                  Icons.person),
                              style: TextStyle(
                                  color: Color.fromRGBO(200, 200, 200, 1)),
                              //TextFormField title background color change

                              //onChanged: _onChanged,
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: validateName,
                              onSaved: (String val) {
                                nom = val;
                              },
                              keyboardType: TextInputType.text,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: Utils.getInputDecoration(
                                  AppLocalization.of(context).hintEmail,
                                  Icons.mail_outline),
                              //onChanged: _onChanged,
                              style: TextStyle(
                                  color: Color.fromRGBO(200, 200, 200, 1)),
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: validateEmail,
                              onSaved: (String val) {
                                email = val;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: Utils.getInputDecoration(
                                  AppLocalization.of(context).hintPhone,
                                  Icons.phone),
                              //onChanged: _onChanged,
                              style: TextStyle(
                                  color: Color.fromRGBO(200, 200, 200, 1)),
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: validateMobile,
                              onSaved: (String val) {
                                telephone = val;
                              },
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              decoration: Utils.getInputDecoration(
                                  AppLocalization.of(context).hintLocalization,
                                  Icons.room),
                              //onChanged: _onChanged,
                              style: TextStyle(
                                  color: Color.fromRGBO(200, 200, 200, 1)),
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: validateCity,
                              onSaved: (String val) {
                                ville = val;
                              },
                              keyboardType: TextInputType.streetAddress,
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: RaisedButton(
                          onPressed: () async {
                            print("enterrr");

                            if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                              _formKey.currentState.save();
                              setState(() {
                                visible = true;
                              });
                              print("good");
                              setState(() {
                                visible = true;
                              });

                              HttpPostRequest.register_request(
                                      nom, email, telephone, ville)
                                  .then((String result) async {
                                //  await Future.delayed(Duration(seconds: 5));
                                print("result");
                                print(result);

                                if (result == "error") {
                                  setState(() {
                                    visible = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: AppLocalization.of(context)
                                          .errorcomptenotexist,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  if (result == "exit") {
                                    setState(() {
                                      visible = false;
                                    });
                                  } else {
                                    setState(() {
                                      code0 = int.parse(result);
                                      visible = false;
                                    });

                                    initPlatformState(result);
                                    _displayDialog(context, telephone);
                                  }
                                }
                              });

                              await Future.delayed(Duration(seconds: 20));

                              setState(() {
                                visible = false;
                              });
                            } else {
//    If all data are not valid then start auto validation.
                              //  print("badd");
                              setState(() {
                                _autoValidate = true;
                              });
                            }

                            /*  Navigator.pushReplacementNamed(context, '/login',
                              arguments: <String, dynamic>{});*/
                          },
                          color: MyTheme.button,
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
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      AppLocalization.of(context).save,
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
                            left: 30, right: 30, top: 0, bottom: 20),
                        child: RaisedButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login',
                                arguments: <String, dynamic>{});
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                              side:
                                  BorderSide(color: MyTheme.button, width: 2)),
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
                                      AppLocalization.of(context)
                                          .alreadyHaveAccount,
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
                  )
                ],
              ),
              visible ? Load.loadSubmit(context) : Container()
            ]),
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return AppLocalization.of(context).validEmail;
    else
      return null;
  }

  String validateName(String value) {
    if (value.length < 3)
      return AppLocalization.of(context).validname;
    else
      return null;
  }

  String validateCity(String value) {
    if (value.length < 3)
      return AppLocalization.of(context).validville;
    else
      return null;
  }

  void _validateInputs10() {
    //  Navigator.of(context).pop();
//    If all data are correct then save data to out variables

    Fluttertoast.showToast(
        msg: AppLocalization.of(context).succeswelcome,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0);

    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  _displayDialog(BuildContext context, phone) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Vérifier le ' + phone,
              style: TextStyle(
                  fontSize: 15.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gotik'),
              textAlign: TextAlign.center,
            ),
            content: Container(
                height: 150.0,
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 20.0),
                        child: Text(
                          "En attente de détection d'un SMS envoyé au ",
                          style: TextStyle(
                              color: Colors.black, fontFamily: "Sofia"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 0.0),
                        child: Text(
                          phone,
                          style: TextStyle(
                              fontSize: 15.5,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Gotik'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _timer.cancel();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 10.0),
                          child: Text(
                            "Numéro incorect ?",
                            style: TextStyle(
                                color: Colors.blue, fontFamily: "Sofia"),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 100.0,
                        child: TextFormField(
                          validator: validateName,
                          controller: texttt,
                          onChanged: (text) {
                            print(text.length);
                            if (text.toString() == code0.toString()) {
                              _validateInputs10();
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Code",
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: "sofia")),
                          onSaved: (String val) {
                            _name = val;
                          },
                        ),
                      )
                    ])),
            actions: <Widget>[],
          );
        });
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 9)
      return AppLocalization.of(context).checkphonenumber;
    else
      return null;
  }
}
