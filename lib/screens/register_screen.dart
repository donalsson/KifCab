import 'package:flutter/material.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/gestures.dart';

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
      appBar: AppBar(
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
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          //color: MyTheme.navBar,
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
                  height: 20,
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/login.png"),
                ),
                SizedBox(
                  height: 40,
                ),
                FormBuilder(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Container(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Column(
                        children: <Widget>[
                          FormBuilderTextField(
                            name: 'name',
                            decoration: Utils.getInputDecoration(
                                AppLocalization.of(context).hintName,
                                Icons.person),
                            style: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1)),
                            //TextFormField title background color change

                            //onChanged: _onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderTextField(
                            name: 'email',
                            decoration: Utils.getInputDecoration(
                                AppLocalization.of(context).hintEmail,
                                Icons.mail_outline),
                            //onChanged: _onChanged,
                            style: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1)),
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderTextField(
                            name: 'phone',
                            decoration: Utils.getInputDecoration(
                                AppLocalization.of(context).hintPhone,
                                Icons.phone),
                            //onChanged: _onChanged,
                            style: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1)),
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          FormBuilderTextField(
                            name: 'address',
                            decoration: Utils.getInputDecoration(
                                AppLocalization.of(context).hintLocalization,
                                Icons.room),
                            //onChanged: _onChanged,
                            style: TextStyle(
                                color: Color.fromRGBO(200, 200, 200, 1)),
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
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
                        onPressed: () {},
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
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login',
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
          ),
        ),
      ),
    );
  }
}
