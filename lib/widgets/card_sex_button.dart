
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/colors.dart';

class CardSexButton extends StatelessWidget {
  final VoidCallback onTap;
  final int index;
  final int selectedIndex;
  final String text;
  CardSexButton(
      {@required this.index,
        @required this.selectedIndex,
        @required this.text,
        @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,

        child: Opacity(
            opacity: 1,
            child: Container(
              color: selectedIndex == index? MyTheme.primaryColor : Colors.white,

              padding: EdgeInsets.all(12),
              child: Text(
                text,
                style: new TextStyle(
                    color: MyTheme.navBar,
                    fontSize: 12,
                    fontWeight:selectedIndex == index? FontWeight.w800 : FontWeight.w400
                    ),
              )
            )));
  }
}