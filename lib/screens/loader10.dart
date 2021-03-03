import 'package:flutter/material.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:kifcab/locale/app_localization.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return new Future(() => false);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.8),
          ),
          child: Center(
            child: Align(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 35.0),
                        child: Text(
                          AppLocalization.of(context).wait,
                          style: Theme.of(context).textTheme.headline6.copyWith(
                              color: MyTheme.primaryDarkColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        ),
                      ),
                      Image.asset('assets/load.gif', height: 80),
                    ])),
          ),
        ));
  }
}
