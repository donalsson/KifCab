import 'dart:convert';
import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import '../core/global.dart' as globals;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:kifcab/utils/colors.dart';

class DriverDetails extends StatefulWidget {
  @override
  _DriverDetailsState createState() => _DriverDetailsState();
}

class _DriverDetailsState extends State<DriverDetails> {
  @override
  void initState() {
    log("Véhicule" + globals.vehicule.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          child: Container(
            color: Colors.transparent,
            // color: MyTheme.primaryDarkColor,
          ),
          preferredSize: Size(0.0, 0.0),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: new BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.8),
            ),
            child: Column(
              children: [
                Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    boxFit: BoxFit.cover,
                    autoplay: true,
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: Duration(milliseconds: 1000),
                    dotSize: 6.0,
                    dotIncreasedColor: MyTheme.button,
                    dotBgColor: Colors.transparent,
                    dotPosition: DotPosition.topRight,
                    dotVerticalPadding: 10.0,
                    showIndicator: true,
                    indicatorBgPadding: 7.0,
                    images: [
                      NetworkImage(
                          'https://smartcab.carrymeandgo.com/assets/uploads/images/' +
                              globals.vehicule["photo1"]),
                      NetworkImage(
                          'https://smartcab.carrymeandgo.com/assets/uploads/images/' +
                              globals.vehicule["photo2"]),
                      NetworkImage(
                          'https://smartcab.carrymeandgo.com/assets/uploads/images/' +
                              globals.vehicule["photo3"]),
                      NetworkImage(
                          'https://smartcab.carrymeandgo.com/assets/uploads/images/' +
                              globals.vehicule["photo4"]),
                      NetworkImage(
                          'https://smartcab.carrymeandgo.com/assets/uploads/images/' +
                              globals.vehicule["photo5"]),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Information sur le Chauffeur',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: MyTheme.button,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Nom :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text: globals.chauffeur["nom"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.accessibility_outlined,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Prénom :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text: globals.chauffeur["prenom"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Télephone :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text: globals.chauffeur["telephone"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Chauffeur depuis :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text: DateFormat(
                                                  'dd-MM-yyyy  à  kk:mm')
                                              .format(new DateTime
                                                  .fromMillisecondsSinceEpoch(int
                                                      .parse(globals.chauffeur[
                                                          "date_creation"]) *
                                                  1000)),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.speaker_notes,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Note : ',
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 18,
                                  )),
                              double.parse(globals.offre["compte"]
                                              ["noteChauffeur"])
                                          .round() <
                                      1
                                  ? InkWell(
                                      onTap: () {
                                        print("ok");
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoile.png',
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoilej.png',
                                        ),
                                      ),
                                    ),
                              double.parse(globals.offre["compte"]
                                              ["noteChauffeur"])
                                          .round() <
                                      2
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoile.png',
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoilej.png',
                                        ),
                                      ),
                                    ),
                              double.parse(globals.offre["compte"]
                                              ["noteChauffeur"])
                                          .round() <
                                      3
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoile.png',
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoilej.png',
                                        ),
                                      ),
                                    ),
                              double.parse(globals.offre["compte"]
                                              ["noteChauffeur"])
                                          .round() <
                                      4
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoile.png',
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoilej.png',
                                        ),
                                      ),
                                    ),
                              double.parse(globals.offre["compte"]
                                              ["noteChauffeur"])
                                          .round() <
                                      5
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          globals.offre["compte"]
                                              ["noteChauffeur"] = 5;
                                        });
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoile.png',
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          globals.offre["compte"]
                                              ["noteChauffeur"] = 5;
                                        });
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 0, 5, 0),
                                        width: 30,
                                        child: Image.asset(
                                          'assets/etoilej.png',
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Information sur le véhicule',
                                style: TextStyle(
                                  fontSize: 25,
                                  color: MyTheme.button,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.drive_eta_outlined,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Marque :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text:
                                              globals.offre["caracteristiques"]
                                                  [0]["valeur"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.description,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Model :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text:
                                              globals.offre["caracteristiques"]
                                                  [1]["valeur"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.date_range_rounded,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Année :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text:
                                              globals.offre["caracteristiques"]
                                                  [3]["valeur"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.color_lens,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Couleur :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text:
                                              globals.offre["caracteristiques"]
                                                  [4]["valeur"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.fiber_manual_record_outlined,
                                color: MyTheme.navBar,
                                size: 22,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width - 68,
                                  child: RichText(
                                    text: new TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18,
                                              color: Colors.black),
                                      children: <TextSpan>[
                                        new TextSpan(
                                            text: "Matricule :   ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        new TextSpan(
                                          text: globals.vehicule["matricule"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
