import 'package:flutter/material.dart';
import 'package:kifcab/utils/colors.dart';

class Utils {
  static InputDecoration getInputDecoration(String hint, IconData prefix) {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
            color: MyTheme.inputBorderColor,
            width: 1.5,
            style: BorderStyle.solid),
      ),
      hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(200, 200, 200, 1)),
      focusedBorder: UnderlineInputBorder(
        //borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(
          color: MyTheme.primaryColor,
          width: 1.5,
        ),
      ),
      border: UnderlineInputBorder(
        //borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(
            color: MyTheme.inputBorderColor,
            width: 1.5,
            style: BorderStyle.solid),
      ),
      contentPadding: EdgeInsets.all(15),
      hintText: hint,
      //suffixIcon: Icon(Icons.check, color: MyTheme.suffixPrefixIcon),
      prefixIcon: Icon(
        prefix,
        color: MyTheme.suffixPrefixIcon,
        size: 15,
      ),
    );
  }

  static InputDecoration getProfileInputDecoration(
      String hint, IconData prefix) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
            color: MyTheme.suffixPrefixIcon,
            width: 1,
            style: BorderStyle.solid),
      ),
      hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color.fromRGBO(100, 100, 100, 1)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: MyTheme.primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
            color: MyTheme.suffixPrefixIcon,
            width: 1,
            style: BorderStyle.solid),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      hintText: hint,
      //suffixIcon: Icon(Icons.check, color: MyTheme.suffixPrefixIcon),
      prefixIcon: Icon(
        prefix,
        color: MyTheme.suffixPrefixIcon,
        size: 15,
      ),
    );
  }

  static InputDecoration getPhoneInputDecoration(String hint, IconData prefix) {
    return InputDecoration(
      /* focusedBorder: UnderlineInputBorder(
        //borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(
          color: MyTheme.primaryColor,
          width: 1.5,
        ),
      ),*/

      contentPadding: EdgeInsets.all(15),

      //suffixIcon: Icon(Icons.check, color: MyTheme.suffixPrefixIcon),
    );
  }
}
