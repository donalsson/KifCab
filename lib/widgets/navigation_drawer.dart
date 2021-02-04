import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/colors.dart';

class navigationDrawer extends StatelessWidget {
  Widget createDrawerHeader(BuildContext context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('assets/bg-old2.png'))),
        child: Container(
          padding: EdgeInsets.all(10),
          color: MyTheme.primaryColor,
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/login.png"),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "John Doe",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Douala",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "611111111",
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                    ],
                  )
                ],
              ))
            ],
          ),
        ));
  }

  Widget createDrawerBodyItem(
      {double marginLeft = 0,IconData icon, String text, GestureTapCallback onTap, Widget trailing}) {
    return ListTile(
      dense: true,
      title: Row(
        children: <Widget>[
          SizedBox(width: marginLeft,),
          Icon(
            icon,
            size: 18,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }

  Widget createExpandableDrawerBodyItem(
      {IconData icon,
      String text,
      GestureTapCallback onTap,
      List<Widget> children}) {
    return ExpansionTile(

      title: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 18,
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          )
        ],
      ),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 130.0,
            child: createDrawerHeader(context),
          ),
          createDrawerBodyItem(
              icon: Icons.home,
              text: AppLocalization.of(context).home,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/home',
                    arguments: <String, dynamic>{});
              }),
          createDrawerBodyItem(
              icon: Icons.local_taxi,
              text: AppLocalization.of(context).history),
          createExpandableDrawerBodyItem(
            icon: Icons.settings,
            text: AppLocalization.of(context).settings,
            children: <Widget>[
              /*createDrawerBodyItem(
                  icon: Icons.person,
                  marginLeft:25,
                  text: AppLocalization.of(context).profil,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/about',
                        arguments: <String, dynamic>{});
                  }),*/
              createDrawerBodyItem(
                  icon: Icons.account_box,
                  marginLeft:25,
                  text: AppLocalization.of(context).myAccount,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/account',
                        arguments: <String, dynamic>{});
                  }),
              createDrawerBodyItem(
                  icon: Icons.airline_seat_recline_normal,
                  marginLeft:25,
                  text: AppLocalization.of(context).becomeDriver,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/become-driver',
                        arguments: <String, dynamic>{});
                  }),
              createDrawerBodyItem(
                  icon: Icons.logout,
                  marginLeft:25,
                  text: AppLocalization.of(context).logout,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/about',
                        arguments: <String, dynamic>{});
                  }),
            ],
          ),
          createDrawerBodyItem(
              icon: Icons.help,
              text: AppLocalization.of(context).help,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/help',
                    arguments: <String, dynamic>{});
              }),
          createDrawerBodyItem(
              icon: Icons.phone_android,
              text: AppLocalization.of(context).aboutApp,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/about',
                    arguments: <String, dynamic>{});
              }),
          createDrawerBodyItem(
              icon: Icons.privacy_tip,
              text: AppLocalization.of(context).privacyPolicies,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/cgi',
                    arguments: <String, dynamic>{});
              }),
          ListTile(
            dense: true,
            title: Text(AppLocalization.of(context).copyrightMessage("2021"),
                style: TextStyle(
                    color: MyTheme.primaryColor, fontWeight: FontWeight.w400)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
