import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';

class BecomeDriverScreen extends StatefulWidget {
  BecomeDriverScreen({
    Key key,
  }) : super(key: key);

  @override
  BecomeDriverScreenState createState() {
    return BecomeDriverScreenState();
  }
}

class BecomeDriverScreenState extends State<BecomeDriverScreen> {
  BecomeDriverScreenState();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
              //color: Colors.white,
              decoration: BoxDecoration(
                //color: MyTheme.stripColor,
                image: DecorationImage(
                  image: AssetImage("assets/slider/1.jpg"),
                  colorFilter: ColorFilter.mode(
                      Color.fromRGBO(0, 0, 0, 0.7), BlendMode.darken),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
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
                              SizedBox(
                                height: 30,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                child: Icon(Icons.person),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFAAAAAA)),
                                  color: Colors.transparent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60)),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                  AppLocalization.of(context)
                                      .processToFollow
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20,
                                        color: Colors.white,
                                      )),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                AppLocalization.of(context)
                                    .processToFollowMessage,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                      letterSpacing: 0.7,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              AutolinkText(
                                text:
                                    AppLocalization.of(context).helpTel(PHONE1),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: MyTheme.colorText,
                                    ),
                                linkStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: MyTheme.colorText,
                                        decoration: TextDecoration.underline),
                                onWebLinkTap: (link) =>
                                    launch("tel:${link.replaceAll(" ", "")}"),
                                onEmailTap: (link) =>
                                    launch("tel:${link.replaceAll(" ", "")}"),
                                onPhoneTap: (link) =>
                                    launch("tel:${link.replaceAll(" ", "")}"),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              AutolinkText(
                                text: AppLocalization.of(context)
                                    .helpWhatsapp(WHATSAPP),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: MyTheme.colorText,
                                    ),
                                linkStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: MyTheme.colorText,
                                        decoration: TextDecoration.underline),
                                onWebLinkTap: (link) =>
                                    launch("sms:${link.replaceAll(" ", "")}"),
                                onEmailTap: (link) =>
                                    launch("sms:${link.replaceAll(" ", "")}"),
                                onPhoneTap: (link) =>
                                    launch("sms:${link.replaceAll(" ", "")}"),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              AutolinkText(
                                text:
                                    AppLocalization.of(context).helpTel(PHONE2),
                                textStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: MyTheme.colorText,
                                    ),
                                linkStyle: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: MyTheme.colorText,
                                        decoration: TextDecoration.underline),
                                onWebLinkTap: (link) =>
                                    launch("tel:${link.replaceAll(" ", "")}"),
                                onEmailTap: (link) =>
                                    launch("tel:${link.replaceAll(" ", "")}"),
                                onPhoneTap: (link) =>
                                    launch("tel:${link.replaceAll(" ", "")}"),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              OutlineButton(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 20),
                                  child: new Text(
                                    AppLocalization.of(context).contactUs,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFFAAAAAA)),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                        context, '/about',
                                        arguments: <String, dynamic>{});
                                  },
                                  borderSide:
                                      BorderSide(color: Color(0xFFAAAAAA)),
                                  focusColor: MyTheme.primaryColor,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(0.0)))
                            ],
                          ),
                        ),
                      ),

                      //_step2
                    ],
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30)),
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
                      color: Colors.white,
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
