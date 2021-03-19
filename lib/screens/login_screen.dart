import 'dart:async';
import 'dart:io';

import 'dart:convert';
import 'dart:ui';
import 'dart:math';

import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:flutter/material.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:kifcab/library/loader.dart';
import 'package:kifcab/core/httpreq.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kifcab/core/preference.dart';
import 'package:kifcab/utils/tcheckconnection.dart';
import 'package:kifcab/main.dart' as app;

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
  }) : super(key: key);

  @override
  LoginScreenState createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  LoginScreenState();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String phoneNumber;
  String phoneIsoCode;
  String _name;
  Timer _timer;
  SmsQuery query = new SmsQuery();
  int code;
  int code0;
  String codeval;
  var texttt = TextEditingController();
  bool _autoValidate = false;
  bool visible = false;
  String confirmedNumber = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String validateName(String value) {
    _name = value;
    if (value.length < 3)
      return AppLocalization.of(context).noAccount;
    else
      return null;
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

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  final _snackBar2 = SnackBar(
    content: Text('Welcome to woolha.com'),
    duration: const Duration(seconds: 10),
    action: SnackBarAction(
      label: 'Click',
      onPressed: () {
        print('Action is clicked');
      },
      textColor: Colors.white,
      disabledTextColor: Colors.grey,
    ),
    onVisible: () {
      print('Snackbar is visible');
    },
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.all(30.0),
    padding: EdgeInsets.all(15.0),
  );

  @override
  Widget build(BuildContext context) {
    techkconnection(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyTheme.navBar,
      /* appBar: AppBar(
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
      ),
      */
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
                  height: 64,
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/login.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(AppLocalization.of(context).enterYourPhone.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        )),
                SizedBox(
                  height: 10,
                ),
                Text(AppLocalization.of(context).examplePhoneNumber,
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                        fontWeight: FontWeight.w200, color: Colors.white)),
                SizedBox(
                  height: 75,
                ),
                new Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1)),
                            decoration: Utils.getInputDecoration(
                                AppLocalization.of(context).hintPhoneLogin,
                                Icons.phone),
                            //onChanged: _onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: validateMobile,
                            onChanged: (String val) {
                              phoneNumber = val;
                            },
                            onSaved: (String val) {
                              phoneNumber = val;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                          TextFormField(
                            style: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1)),
                            decoration: Utils.getInputDecoration(
                                AppLocalization.of(context).activationcode,
                                Icons.lock),
                            //onChanged: _onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: validateCode,
                            obscureText: true,
                            onSaved: (String val) {
                              codeval = val;
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    )),
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
                        onPressed: () async {
                          print("enterrr");
                          if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
                            _formKey.currentState.save();
                            print("good");
                            setState(() {
                              visible = true;
                            });
                            FocusScope.of(context).requestFocus(FocusNode());
                            //  await Future.delayed(Duration(seconds: 5));

                            /*  setState(() {
                            visible = false;
                          });*/
                            HttpPostRequest.login_request(phoneNumber)
                                .then((dynamic result) async {
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
                                if (result == "notallow") {
                                  setState(() {
                                    visible = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: AppLocalization.of(context)
                                          .errornotallow,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  if (result["mot_de_passe"].toString() !=
                                      codeval.toString()) {
                                    setState(() {
                                      visible = false;
                                    });

                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        AppLocalization.of(context)
                                            .erroricorectcode,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15),
                                      ),
                                      duration: Duration(seconds: 3),
                                    ));
                                    /* Scaffold.of(context)
                                        .showSnackBar(_snackBar2);*/
                                    /*  Fluttertoast.showToast(
                                        msg: AppLocalization.of(context)
                                            .erroricorectcode,
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0);*/
                                  } else {
                                    setState(() {
                                      // code0 = int.parse(result);
                                      visible = false;
                                      SharedPreferencesClass.save("userinfos",
                                          "[" + jsonEncode(result) + "]");
                                      _validateInputs10();
                                    });
                                  }
                                }
                              }
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
                                    AppLocalization.of(context).next,
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
                                    AppLocalization.of(context).noAccount,
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
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 70, right: 30),
                  child: RichText(
                    text: TextSpan(
                      text: AppLocalization.of(context).forgetcode,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("zdsd");
                          print(phoneNumber);
                          if (phoneNumber != null && phoneNumber != "") {
                            //   initPlatformState(result);

//    If all data are correct then save data to out variables
                            _formKey.currentState.save();
                            print("good");
                            setState(() {
                              visible = true;
                            });
                            //  await Future.delayed(Duration(seconds: 5));

                            /*  setState(() {
                            visible = false;
                          });*/
                            HttpPostRequest.login_recup(phoneNumber)
                                .then((dynamic result) async {
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
                                if (result == "notallow") {
                                  setState(() {
                                    visible = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: AppLocalization.of(context)
                                          .errornotallow,
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                } else {
                                  setState(() {
                                    visible = false;
                                  });
                                  _displayDialog(context, phoneNumber, result);
                                }
                              }
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: AppLocalization.of(context)
                                    .checkphonenumber,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          color: MyTheme.primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            visible ? Load.loadSubmit(context) : Container()
          ])),
        ),
      ),
    );
  }

  _displayDialog(BuildContext context, phone, user) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromRGBO(200, 200, 200, 1),
            title: Text(
              AppLocalization.of(context).sendnewcode + phone,
              style: TextStyle(
                  fontSize: 15.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Gotik'),
              textAlign: TextAlign.center,
            ),
            content: Container(
                height: 158.0,
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 0.0, right: 0.0, top: 20.0),
                        child: Text(
                          AppLocalization.of(context).sendacticode,
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
                          // _timer.cancel();
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0.0, top: 10.0),
                          child: Text(
                            AppLocalization.of(context).incorectphon,
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
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.black54),
                          onChanged: (text) {
                            print(text.length);
                            if (text.toString() ==
                                user["mot_de_passe"].toString()) {
                              SharedPreferencesClass.save(
                                  "userinfos", "[" + jsonEncode(user) + "]");
                              _validateInputs10();
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Code",
                              hintStyle: TextStyle(
                                  color: Colors.black38, fontFamily: "sofia")),
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

  void _validateInputs10() {
    //  Navigator.of(context).pop();
//    If all data are correct then save data to out variables

    /*  Fluttertoast.showToast(
        msg: AppLocalization.of(context).succeswelcome,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green[400],
        textColor: Colors.white,
        fontSize: 16.0);*/
    app.main();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }

  String validateMobile(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 9)
      return AppLocalization.of(context).checkphonenumber;
    else
      return null;
  }

  String validateCode(String value) {
// Indian Mobile number are of 10 digit only
    if (value.length != 6)
      return AppLocalization.of(context).checkcodenumber;
    else
      return null;
  }
}
