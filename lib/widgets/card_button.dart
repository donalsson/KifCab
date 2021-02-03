
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/colors.dart';

class CardButton extends StatelessWidget {
  final VoidCallback onTap;
  final int index;
  final int selectedIndex;
  final String imageUrl;
  final bool isAsset;
  final String text;
  CardButton(
      {@required this.index,
        @required this.selectedIndex,
        @required this.imageUrl,
        @required this.isAsset,
        @required this.text,
        @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,

        child: Opacity(
            opacity: selectedIndex == index?1: 0.3,
            child: Container(

              padding: EdgeInsets.all(10),
              child: Column(
                children: [

                  CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      backgroundImage: isAsset? AssetImage(imageUrl):NetworkImage(imageUrl)
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    text,
                    style: new TextStyle(
                        color: MyTheme.navBar,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w400),
                  )
                ],
              ),
            )));
  }
}