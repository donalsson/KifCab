import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/models/Command.dart';
import 'package:kifcab/models/UserMod.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/widgets/card_button.dart';
import 'package:kifcab/widgets/card_sex_button.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:expandable/expandable.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({
    Key key,
  }) : super(key: key);

  @override
  HistoryScreenState createState() {
    return HistoryScreenState();
  }
}

class HistoryScreenState extends State<HistoryScreen> {
  HistoryScreenState();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserMod currentUser;
  int selectedMenuIndex = 0; //0: Male, 1:Female

  List<Command> _depots = [];
  List<Command> _courses = [];
  List<Command> _locations = [];
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
    _depots = List.generate(15, (index) {
      return Command(
          index.toString(),
          index % 5,
          DateTime.now().add(Duration(hours: index)),
          "Depart dépot ${index + 1}",
          "Arrivé dépot ${index + 1}",
          5 + index,
          100 * (index + 1).toDouble());
    });
    _courses = List.generate(15, (index) {
      return Command(
          index.toString(),
          index % 5,
          DateTime.now().add(Duration(hours: index)),
          "Course dépot ${index + 1}",
          "Course dépot ${index + 1}",
          5 + index,
          100 * (index + 1).toDouble());
    });
    _locations = List.generate(15, (index) {
      return Command(
          index.toString(),
          index % 5,
          DateTime.now().add(Duration(hours: index)),
          "Location dépot ${index + 1}",
          "Location dépot ${index + 1}",
          5 + index,
          100 * (index + 1).toDouble());
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String getStatusHTML(int n, String txt, BuildContext context) {
    if (n == 0) {
      if (txt == 'true')
        return AppLocalization.of(context).reseted;
      else
        return "bg-gray-dark";
    }
    if (n == 1) {
      if (txt == 'true')
        return AppLocalization.of(context).waiting;
      else
        return "bg-blue-dark";
    }
    if (n == 2) {
      if (txt == 'true')
        return AppLocalization.of(context).programmed;
      else
        return "bg-red-dark";
    }
    if (n == 3) {
      if (txt == 'true')
        return AppLocalization.of(context).inProgress;
      else
        return "bg-yellow-dark";
    }
    if (n == 4) {
      if (txt == 'true')
        return AppLocalization.of(context).ended;
      else
        return "bg-green-dark";
    }
    return "";
  }

  Color getStatusColor(int n) {
    switch (n) {
      case 0:
        return Colors.blueGrey;
      case 1:
        return Colors.blueAccent;
      case 2:
        return Colors.redAccent;
      case 3:
        return Colors.yellow[600];
      case 4:
        return Colors.greenAccent;
      default:
        return Colors.black;
    }
  }
  bool isMe(){
    //TODO
    return false;
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
                                top: AppBar().preferredSize.height,
                                left: 15,
                                right: 15,
                                bottom: 25),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                              AppLocalization.of(context)
                                                  .historyPageTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                          SizedBox(
                                            height: 07,
                                          ),
                                          Text(
                                              AppLocalization.of(context)
                                                  .history,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300,
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
                                  SizedBox(
                                    height: 0,
                                  ),
                                ],
                              ),
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
                                  selectedIndex: selectedMenuIndex,
                                  text: AppLocalization.of(context).deposit,
                                  onTap: () {
                                    print("Tap elemen");
                                    setState(() {
                                      selectedMenuIndex = 0;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CardSexButton(
                                  index: 1,
                                  selectedIndex: selectedMenuIndex,
                                  text: AppLocalization.of(context).course,
                                  onTap: () {
                                    print("Tap elemen");
                                    setState(() {
                                      selectedMenuIndex = 1;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CardSexButton(
                                  index: 2,
                                  selectedIndex: selectedMenuIndex,
                                  text: AppLocalization.of(context).location,
                                  onTap: () {
                                    print("Tap elemen");
                                    setState(() {
                                      selectedMenuIndex = 2;
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                if(true)CardSexButton(
                                  index: 3,
                                  selectedIndex: selectedMenuIndex,
                                  text: AppLocalization.of(context).finance,
                                  onTap: () {
                                    print("Tap elemen");
                                    setState(() {
                                      selectedMenuIndex = 3;
                                    });
                                  },
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: MyTheme.navBar,
                            thickness: 0.2,
                            height: 1,
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          //DEPOT
                          if (selectedMenuIndex == 0)
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                child: ListView.separated(
                                    key: Key("Depot123"),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Command item = _depots.elementAt(index);
                                      return ExpandablePanel(
                                        header: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(item.arrive,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14,
                                                          color: MyTheme.navBar,
                                                        )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  color: getStatusColor(
                                                      item.status),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 7,
                                                      vertical: 3),
                                                  child: Text(
                                                      getStatusHTML(item.status,
                                                          "true", context),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 13,
                                                            color: Colors.white,
                                                          )),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        collapsed: Text(
                                            DateFormat.yMMMd()
                                                .add_Hms()
                                                .format(item.date_creation),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12,
                                                  color: MyTheme.navBar,
                                                )),
                                        expanded: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                AppLocalization.of(context)
                                                    .depositInfos,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                      color: MyTheme.navBar,
                                                    )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                                context)
                                                            .startPoint,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                          color: MyTheme.navBar,
                                                        )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(item.depart,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color: MyTheme.navBar,
                                                        ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                                context)
                                                            .createdAt,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 13,
                                                          color: MyTheme.navBar,
                                                        )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    DateFormat.yMMMd()
                                                        .add_Hms()
                                                        .format(
                                                            item.date_creation),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                          color: MyTheme.navBar,
                                                        ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .destination,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    item.arrive,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  if(item.status == 2) SizedBox(
                                                      width: 75.0,
                                                      height:30,
                                                      child:RaisedButton(
                                                    onPressed: () {
                                                      print("Démarrer" );
                                                      print(item.id );
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(0.0),
                                                        ),
                                                        side: BorderSide(color: MyTheme.button, width: 0)),
                                                    color: MyTheme.button,
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text(AppLocalization.of(context).start, style: TextStyle(color:Colors.black),),)),
                                                  if(item.status == 3) SizedBox(
                                                    width: 10,
                                                  ),
                                                  if(item.status == 3)SizedBox(
                                                      width: 75.0,
                                                      height:30,
                                                    child:RaisedButton(
                                                    onPressed: () {
                                                      print("Terminer" );
                                                      print(item.id );
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(0.0),
                                                        ),
                                                        side: BorderSide(color: MyTheme.button, width: 0)),
                                                    color:  MyTheme.button,
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text(AppLocalization.of(context).end, style: TextStyle(color:Colors.black),),)),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                      width: 60.0,
                                                      height:30,
                                                      child:RaisedButton(
                                                    onPressed: () {
                                                      print("Ouvrir" );
                                                      print(item.id );
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(0.0),
                                                        ),
                                                        side: BorderSide(color: Colors.black, width: 0)),
                                                    color: Colors.black,
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                                                    child: Text(AppLocalization.of(context).open, style: TextStyle(color:Colors.white),),)),
                                                  if(item.status <3 && isMe()) SizedBox(
                                                    width: 10,
                                                  ),
                                                  if(item.status <3 && isMe())SizedBox(
                                                      width: 75.0,
                                                      height:30,
                                                     child:RaisedButton(
                                                    onPressed: () {
                                                      print("Modifier" );
                                                      print(item.id );
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(0.0),
                                                        ),
                                                        side: BorderSide(color: Colors.black, width: 0)),
                                                    color: Colors.black,
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text(AppLocalization.of(context).update, style: TextStyle(color:Colors.white),),)),

                                                  if((!isMe() && item.status >1 && item.status <3) || (isMe() && item.status !=0 && item.status !=4)) SizedBox(
                                                    width: 10,
                                                  ),
                                                  if((!isMe() && item.status >1 && item.status <3) || (isMe() && item.status !=0 && item.status !=4)) SizedBox(
                                                      width: 75.0,
                                                      height:30,
                                                    child:RaisedButton(
                                                    onPressed: () {
                                                      print("Annuler" );
                                                      print(item.id );
                                                    },
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(0.0),
                                                        ),
                                                        side: BorderSide(color:Colors.black, width: 0)),
                                                    color: Colors.black,
                                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                    child: Text(AppLocalization.of(context).reset, style: TextStyle(color:Colors.white),),))
                                                ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        tapHeaderToExpand: true,
                                        hasIcon: true,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          color: MyTheme.navBar,
                                          thickness: 0.2,
                                          height: 1,
                                        ),
                                    itemCount: _depots.length),
                              ),
                            ),
                          //COURSE
                          if (selectedMenuIndex == 1)
                            Container(
                              padding:
                              const EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                child: ListView.separated(
                                    key: Key("Course123"),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Command item = _courses.elementAt(index);
                                      return ExpandablePanel(
                                        header: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(item.arrive,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 14,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  color: getStatusColor(
                                                      item.status),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 7,
                                                      vertical: 3),
                                                  child: Text(
                                                      getStatusHTML(item.status,
                                                          "true", context),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        collapsed: Text(
                                            DateFormat.yMMMd()
                                                .add_Hms()
                                                .format(item.date_creation),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: MyTheme.navBar,
                                            )),
                                        expanded: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                AppLocalization.of(context)
                                                    .courseInfos,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: 14,
                                                  color: MyTheme.navBar,
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .startPoint,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(item.depart,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .createdAt,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    DateFormat.yMMMd()
                                                        .add_Hms()
                                                        .format(
                                                        item.date_creation),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .countHours,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    "${item.hdebut}h",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .price,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    "${item.cout} XAF",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                if(item.status == 2) SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Démarrer" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: MyTheme.button, width: 0)),
                                                      color: MyTheme.button,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).start, style: TextStyle(color:Colors.black),),)),
                                                if(item.status == 3) SizedBox(
                                                  width: 10,
                                                ),
                                                if(item.status == 3)SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Terminer" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: MyTheme.button, width: 0)),
                                                      color:  MyTheme.button,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).end, style: TextStyle(color:Colors.black),),)),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                    width: 60.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Ouvrir" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: Colors.black, width: 0)),
                                                      color: Colors.black,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                                                      child: Text(AppLocalization.of(context).open, style: TextStyle(color:Colors.white),),)),
                                                if(item.status <3 && isMe()) SizedBox(
                                                  width: 10,
                                                ),
                                                if(item.status <3 && isMe())SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Modifier" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: Colors.black, width: 0)),
                                                      color: Colors.black,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).update, style: TextStyle(color:Colors.white),),)),

                                                if((!isMe() && item.status >1 && item.status <3) || (isMe() && item.status !=0 && item.status !=4)) SizedBox(
                                                  width: 10,
                                                ),
                                                if((!isMe() && item.status >1 && item.status <3) || (isMe() && item.status !=0 && item.status !=4)) SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Annuler" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color:Colors.black, width: 0)),
                                                      color: Colors.black,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).reset, style: TextStyle(color:Colors.white),),))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        tapHeaderToExpand: true,
                                        hasIcon: true,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          color: MyTheme.navBar,
                                          thickness: 0.2,
                                          height: 1,
                                        ),
                                    itemCount: _courses.length),
                              ),
                            ),
                          if (selectedMenuIndex == 2)
                            Container(
                              padding:
                              const EdgeInsets.only(left: 15, right: 15),
                              child: Container(
                                child: ListView.separated(
                                    key: Key("Location123"),
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      Command item = _locations.elementAt(index);
                                      return ExpandablePanel(
                                        header: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(item.arrive,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w700,
                                                      fontSize: 14,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  color: getStatusColor(
                                                      item.status),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 7,
                                                      vertical: 3),
                                                  child: Text(
                                                      getStatusHTML(item.status,
                                                          "true", context),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                      )),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                        collapsed: Text(
                                            DateFormat.yMMMd()
                                                .add_Hms()
                                                .format(item.date_creation),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 12,
                                              color: MyTheme.navBar,
                                            )),
                                        expanded: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                AppLocalization.of(context)
                                                    .locationInfos,
                                                softWrap: true,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                  fontWeight:
                                                  FontWeight.w400,
                                                  fontSize: 14,
                                                  color: MyTheme.navBar,
                                                )),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .startPoint,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(item.depart,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .createdAt,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    DateFormat.yMMMd()
                                                        .add_Hms()
                                                        .format(
                                                        item.date_creation),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .destination,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    item.arrive,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    "- " +
                                                        AppLocalization.of(
                                                            context)
                                                            .price,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 13,
                                                      color: MyTheme.navBar,
                                                    )),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    "${item.cout} XAF",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                      fontWeight:
                                                      FontWeight.w400,
                                                      fontSize: 12,
                                                      color: MyTheme.navBar,
                                                    ))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                if(item.status == 2) SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Démarrer" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: MyTheme.button, width: 0)),
                                                      color: MyTheme.button,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).start, style: TextStyle(color:Colors.black),),)),
                                                if(item.status == 3) SizedBox(
                                                  width: 10,
                                                ),
                                                if(item.status == 3)SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Terminer" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: MyTheme.button, width: 0)),
                                                      color:  MyTheme.button,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).end, style: TextStyle(color:Colors.black),),)),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                    width: 60.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Ouvrir" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: Colors.black, width: 0)),
                                                      color: Colors.black,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),

                                                      child: Text(AppLocalization.of(context).open, style: TextStyle(color:Colors.white),),)),
                                                if(item.status <3 && isMe()) SizedBox(
                                                  width: 10,
                                                ),
                                                if(item.status <3 && isMe())SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Modifier" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color: Colors.black, width: 0)),
                                                      color: Colors.black,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).update, style: TextStyle(color:Colors.white),),)),

                                                if((!isMe() && item.status >1 && item.status <3) || (isMe() && item.status !=0 && item.status !=4)) SizedBox(
                                                  width: 10,
                                                ),
                                                if((!isMe() && item.status >1 && item.status <3) || (isMe() && item.status !=0 && item.status !=4)) SizedBox(
                                                    width: 75.0,
                                                    height:30,
                                                    child:RaisedButton(
                                                      onPressed: () {
                                                        print("Annuler" );
                                                        print(item.id );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(0.0),
                                                          ),
                                                          side: BorderSide(color:Colors.black, width: 0)),
                                                      color: Colors.black,
                                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                      child: Text(AppLocalization.of(context).reset, style: TextStyle(color:Colors.white),),))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        tapHeaderToExpand: true,
                                        hasIcon: true,
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        Divider(
                                          color: MyTheme.navBar,
                                          thickness: 0.2,
                                          height: 1,
                                        ),
                                    itemCount: _locations.length),
                              ),
                            ),
                          if (selectedMenuIndex == 3)
                            Container(
                              padding:
                              const EdgeInsets.only(left: 15, right: 15),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Text(
                                          "- " +
                                              AppLocalization.of(
                                                  context)
                                                  .ca,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 15,
                                            color: MyTheme.navBar,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("100 000",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 14,
                                            color: MyTheme.navBar,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "- " +
                                              AppLocalization.of(
                                                  context)
                                                  .creditCa,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 15,
                                            color: MyTheme.navBar,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("30 000",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 14,
                                            color: MyTheme.navBar,
                                          ))
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          "- " +
                                              AppLocalization.of(
                                                  context)
                                                  .detteCa,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontWeight:
                                            FontWeight.w500,
                                            fontSize: 15,
                                            color: MyTheme.navBar,
                                          )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "50 000",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(
                                            fontWeight:
                                            FontWeight.w400,
                                            fontSize: 14,
                                            color: MyTheme.navBar,
                                          ))
                                    ],
                                  ),


                                ],
                              ),
                            ),
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
