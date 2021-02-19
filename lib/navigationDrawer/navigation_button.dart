import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/utils/colors.dart';

class NavigationButton extends StatelessWidget {
  final VoidCallback onTap;
  final Color backColor;
  final Color textColor;
  final IconData icon;
  final String text;
  NavigationButton(
      {@required this.backColor,  @required this.textColor = Colors.white, @required this.icon, @required this.text, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: new Container(
        decoration: BoxDecoration(
          color: this.backColor,
          boxShadow: [
            BoxShadow(
              color: this.backColor,
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(3, 0), // changes position of shadow
            ),
          ],
        ),
        child: new Material(
          child: new InkWell(
            onTap: this.onTap,
            child: new Container(
              padding: const EdgeInsets.all(08),
              child: Column(
                children: [
                  Icon(
                    this.icon,
                    color: this.textColor,
                    size: 25,
                  ),
                  Text(this.text,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: this.textColor,))
                ],
              ),
            ),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }
}


