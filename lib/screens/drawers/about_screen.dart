import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';





class AboutScreen extends StatefulWidget {
  AboutScreen({

    Key key,
  }) : super(key: key);

  @override
  AboutScreenState createState() {
    return AboutScreenState();
  }
}


class AboutScreenState extends State<AboutScreen> {
  AboutScreenState();

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
            color: Colors.white,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    decoration: BoxDecoration(
                      //color: MyTheme.stripColor,
                      image: DecorationImage(
                        image: AssetImage("assets/pictures/2.jpg"),
                        colorFilter: ColorFilter.mode(Color.fromRGBO(0, 0, 0, 0.7), BlendMode.darken),
                        fit: BoxFit.cover,
                      ),
                    ),

                    child: Center(
                      // Center is a layout widget. It takes a single child and positions it
                      // in the middle of the parent.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          Row(children: <Widget>[
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(AppLocalization.of(context).aboutUs,
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
                                  Text(AppLocalization.of(context).aboutUsSubtitle,
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
                              Icons.location_city,
                              color: Color(0xFAFFFFFF),
                              size: 30,
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

                  Container(
                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        SizedBox(height: 5,),
                        Text(
                          AppLocalization.of(context).whoAreUs,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w300,
                            color: MyTheme.navBar,
                          ),
                        ),
                        SizedBox(height: 15,),
                        Text(
                          AppLocalization.of(context).whoAreUsMessage,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: MyTheme.colorText,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          AppLocalization.of(context).moreAlso,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: MyTheme.navBar,
                          ),
                        ),
                        SizedBox(height: 15,),
                        Text(
                          AppLocalization.of(context).moreAlsoMessage1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: MyTheme.colorText,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          AppLocalization.of(context).moreAlsoMessage2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: MyTheme.colorText,
                          ),
                        ),
                        SizedBox(height: 20,),
                        Divider(color: MyTheme.navBar, thickness: 0.2,),
                        SizedBox(height: 20,),
                        Text(
                          AppLocalization.of(context).contact+':',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: MyTheme.navBar,
                          ),
                        ),

                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 15, color: MyTheme.colorText,),
                            SizedBox(width: 10,),
                            AutolinkText(
                              text: AppLocalization.of(context).helpTel(PHONE1),
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
                                  decoration: TextDecoration.underline
                              ),
                              onWebLinkTap: (link) => launch("tel:${link.replaceAll(" ", "")}"),
                              onEmailTap: (link) => launch("tel:${link.replaceAll(" ", "")}"),
                              onPhoneTap: (link) => launch("tel:${link.replaceAll(" ", "")}"),
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 15, color: MyTheme.colorText,),
                            SizedBox(width: 10,),
                            AutolinkText(
                              text: AppLocalization.of(context).helpWhatsapp(WHATSAPP),
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
                                  decoration: TextDecoration.underline
                              ),
                              onWebLinkTap: (link) => launch("sms:${link.replaceAll(" ", "")}"),
                              onEmailTap: (link) => launch("sms:${link.replaceAll(" ", "")}"),
                              onPhoneTap: (link) => launch("sms:${link.replaceAll(" ", "")}"),
                            )
                          ],
                        ),
                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Icon(Icons.phone, size: 15, color: MyTheme.colorText,),
                            SizedBox(width: 10,),

                            AutolinkText(
                              text: AppLocalization.of(context).helpTel(PHONE2),
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
                                  decoration: TextDecoration.underline
                              ),
                              onWebLinkTap: (link) => launch("tel:${link.replaceAll(" ", "")}"),
                              onEmailTap: (link) => launch("tel:${link.replaceAll(" ", "")}"),
                              onPhoneTap: (link) => launch("tel:${link.replaceAll(" ", "")}"),
                            )
                          ],
                        ),

                        SizedBox(height: 15,),
                        Row(
                          children: [
                            Icon(Icons.mail, size: 15, color: MyTheme.colorText,),
                            SizedBox(width: 10,),
                            AutolinkText(
                              text: EMAIL,
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
                                  decoration: TextDecoration.underline
                              ),
                              onWebLinkTap: (link) => launch("mailto:${link.replaceAll(" ", "")}"),
                              onEmailTap: (link) => launch("mailto:${link.replaceAll(" ", "")}"),
                              onPhoneTap: (link) => launch("mailto:${link.replaceAll(" ", "")}"),
                            )
                          ],
                        ),
                      ],
                    ),
                  )


                  //_step2
                ],
              ),
            ),
          ),



          Positioned(  top:0, left: 0, right: 0, child:   Container(
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
          ),)
        ],
      ),
    );
  }
}
