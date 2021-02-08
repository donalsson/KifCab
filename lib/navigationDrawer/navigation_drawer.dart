import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/colors.dart';
import '../core/global.dart' as globals;
import 'package:cached_network_image/cached_network_image.dart';

class navigationDrawer extends StatelessWidget {
  Widget createDrawerHeader(BuildContext context) {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('images/bg_header.jpeg'))),
        child: Container(
          padding: EdgeInsets.all(10),
          color: MyTheme.primaryColor,
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    CachedNetworkImageProvider(globals.userinfos.photo),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    globals.userinfos.nom.toString(),
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
                        globals.userinfos.localisation,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        globals.userinfos.telephone,
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
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      dense: true,
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
      onTap: onTap,
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
              icon: Icons.home, text: AppLocalization.of(context).home),
          createDrawerBodyItem(
              icon: Icons.local_taxi,
              text: AppLocalization.of(context).history),
          createDrawerBodyItem(
              icon: Icons.settings, text: AppLocalization.of(context).settings),
          createDrawerBodyItem(
              icon: Icons.help, text: AppLocalization.of(context).help),
          createDrawerBodyItem(
              icon: Icons.phone_android,
              text: AppLocalization.of(context).aboutApp),
          createDrawerBodyItem(
              icon: Icons.privacy_tip,
              text: AppLocalization.of(context).privacyPolicies),
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
