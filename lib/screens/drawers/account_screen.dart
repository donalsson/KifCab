import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/models/UserMod.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/widgets/card_button.dart';
import 'package:kifcab/widgets/card_sex_button.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({
    Key key,
  }) : super(key: key);

  @override
  AccountScreenState createState() {
    return AccountScreenState();
  }
}

class AccountScreenState extends State<AccountScreen> {
  AccountScreenState();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserMod currentUser;
  int _selectedSexIndex = 0; //0: Male, 1:Female
  @override
  void initState() {
    super.initState();
    currentUser = UserMod.fill(
      id_compte: "",
      nom: "TANDA",
      prenom: "Cedric",
      telephone: "691681456",
      sexe: "M",
      description: "Je suis comme je suis...",
      email: "tandacedric@gmail.com",
      profil: "",
      localisation: "Yaoundé",
      date_naissance: "1994/09/02",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyTheme.stripColor,
      appBar: PreferredSize(
        child: Container(
          color: Colors.transparent,
          // color: MyTheme.primaryDarkColor,
        ),
        preferredSize: Size(0.0, 0.0),
      ),
      drawer: NavigationDrawer(),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            color: Colors.white,
            /*decoration: BoxDecoration(
                //color: MyTheme.stripColor,
                image: DecorationImage(
                  image: AssetImage("assets/slider/1.jpg"),
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.7), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),*/

            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      // Center is a layout widget. It takes a single child and positions it
                      // in the middle of the parent.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: AppBar().preferredSize.height - 20,
                                left: 15,
                                right: 15,
                                bottom: 25),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage:
                                      AssetImage("assets/login.png"),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentUser?.prenom +
                                          " " +
                                          currentUser?.nom,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14,
                                              color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: Color(0xFF444444),
                                          size: 14,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          AppLocalization.of(context)
                                              .accountInformations,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                  color: MyTheme.navBar),
                                        ),
                                      ],
                                    )
                                  ],
                                ))
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CardSexButton(
                                  index: 0,
                                  selectedIndex: _selectedSexIndex,
                                  text: AppLocalization.of(context).male,
                                  onTap: () {
                                    print("Tap elemen");
                                    setState(() {
                                      _selectedSexIndex = 0;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                CardSexButton(
                                  index: 1,
                                  selectedIndex: _selectedSexIndex,
                                  text: AppLocalization.of(context).female,
                                  onTap: () {
                                    print("Tap elemen");
                                    setState(() {
                                      _selectedSexIndex = 1;
                                    });
                                  },
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    AppLocalization.of(context).yourSex(
                                        _selectedSexIndex == 0 ? 'M' : 'F'),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: new Form(
                                key: _formKey,
                                //autovalidate: _autoValidate,
                                child: Container(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                      TextFormField(
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 1)),
                                        decoration:
                                            Utils.getProfileInputDecoration(
                                                AppLocalization.of(context)
                                                    .enterYourFirstName,
                                                Icons.person),
                                        //onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        //validator: validateMobile,
                                        onChanged: (String val) {},
                                        onSaved: (String val) {},
                                        keyboardType: TextInputType.name,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 1)),
                                        decoration:
                                            Utils.getProfileInputDecoration(
                                                AppLocalization.of(context)
                                                    .enterYourLastName,
                                                Icons.person),
                                        //onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        //validator: validateMobile,
                                        onChanged: (String val) {},
                                        onSaved: (String val) {},
                                        keyboardType: TextInputType.name,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 1)),
                                        decoration:
                                            Utils.getProfileInputDecoration(
                                                AppLocalization.of(context)
                                                    .enterYourLocalization,
                                                Icons.room),
                                        //onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        //validator: validateMobile,
                                        onChanged: (String val) {},
                                        onSaved: (String val) {},
                                        keyboardType:
                                            TextInputType.streetAddress,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 1)),
                                        decoration:
                                            Utils.getProfileInputDecoration(
                                                AppLocalization.of(context)
                                                    .enterYourPhone,
                                                Icons.call),
                                        //onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        //validator: validateMobile,
                                        onChanged: (String val) {},
                                        onSaved: (String val) {},
                                        keyboardType: TextInputType.phone,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      TextFormField(
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 1)),
                                        decoration:
                                            Utils.getProfileInputDecoration(
                                                AppLocalization.of(context)
                                                    .enterYourEmail,
                                                Icons.call),
                                        //onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        //validator: validateMobile,
                                        onChanged: (String val) {},
                                        onSaved: (String val) {},
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      /* TextFormField(
                                        style: TextStyle(
                                            color:
                                            Color.fromRGBO(100, 100, 100, 1)),
                                        decoration: Utils.getProfileInputDecoration(
                                            AppLocalization.of(context)
                                                .enterYourBirthdate,
                                            Icons.calendar_today),
                                        //onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        //validator: validateMobile,
                                        onChanged: (String val) {},
                                        onSaved: (String val) {},
                                        keyboardType: TextInputType.datetime,
                                      ),*/
                                      FormBuilderDateTimePicker(
                                        name: 'date',
                                        format: DateFormat('yyyy/MM/dd'),
                                        // onChanged: _onChanged,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 1)),
                                        inputType: InputType.date,
                                        decoration:
                                            Utils.getProfileInputDecoration(
                                                AppLocalization.of(context)
                                                    .enterYourBirthdate,
                                                Icons.calendar_today),
                                        //initialTime: TimeOfDay(hour: 8, minute: 0),
                                        initialValue: DateTime.now(),
                                        // enabled: true,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        AppLocalization.of(context)
                                            .tellUsSomethingAboutYou,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13,
                                                color: Color.fromRGBO(
                                                    100, 100, 100, 1)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        minLines: 4,
                                        maxLines: 4,
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                100, 100, 100, 1)),
                                        decoration:
                                            Utils.getProfileInputDecoration(
                                                "", null),
                                        //onChanged: _onChanged,
                                        // valueTransformer: (text) => num.tryParse(text),
                                        //validator: validateMobile,
                                        onChanged: (String val) {},
                                        onSaved: (String val) {},
                                        keyboardType: TextInputType.datetime,
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 30,
                                                bottom: 30,),
                                            child: RaisedButton(
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              onPressed: () async {
                                                print("enterrr");

                                                /*  Navigator.pushReplacementNamed(context, '/login', arguments: <String, dynamic>{});*/
                                              },
                                              color: MyTheme.button,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(0.0),
                                                ),
                                              ),
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 0),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    SizedBox(width: 15,),
                                                    Container(
                                                      //color: Color.fromRGBO(229, 188, 1, 1),
                                                      color: Color.fromRGBO(
                                                          208, 171, 4, 1),
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
                                                          AppLocalization.of(
                                                                  context)
                                                              .save,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                    ]))),
                          )
                        ],
                      ),
                    ),
                  ),

                  //_step2
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              height: AppBar().preferredSize.height,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      child: GestureDetector(
                    onTap: () {
                      if (_scaffoldKey.currentState.isDrawerOpen) {
                        _scaffoldKey.currentState.openEndDrawer();
                      } else {
                        _scaffoldKey.currentState.openDrawer();
                      }
                    },
                    child: Icon(
                      Icons.menu,
                      color: Color(0xFFCACACA),
                      size: 20,
                    ),
                  )),
                  Container(
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
            ),
          )
        ],
      ),
    );
  }
}
