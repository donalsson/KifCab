import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/navigationDrawer/navigation_button.dart';
import 'package:kifcab/navigationDrawer/navigation_drawer.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DepotScreen extends StatefulWidget {
  const DepotScreen({
    Key key,
  }) : super(key: key);

  @override
  DepotScreenState createState() {
    return DepotScreenState();
  }
}

class DepotScreenState extends State<DepotScreen> {
  DepotScreenState();
  final _formKey = GlobalKey<FormBuilderState>();
  String kGoogleApiKey = GOOGLE_API_KEY;
  final TextEditingController _textControllerFrom = new TextEditingController();
  final TextEditingController _textControllerTo = new TextEditingController();
  bool _showClearButtonInputFrom = false;
  bool _showClearButtonInputTo = false;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
// Light Theme
  final ThemeData lightTheme = ThemeData.light().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.white,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.black,
      textTheme: ButtonTextTheme.primary,
    ),
  );

// Dark Theme
  final ThemeData darkTheme = ThemeData.dark().copyWith(
    // Background color of the FloatingCard
    cardColor: Colors.grey,
    buttonTheme: ButtonThemeData(
      // Select here's button color
      buttonColor: Colors.yellow,
      textTheme: ButtonTextTheme.primary,
    ),
  );

  @override
  void initState() {
    super.initState();
    _textControllerFrom.addListener(() {
      setState(() {
        _showClearButtonInputFrom = _textControllerFrom.text.length > 0;
      });
    });
    _textControllerTo.addListener(() {
      setState(() {
        _showClearButtonInputTo = _textControllerTo.text.length > 0;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.stripColor,
      appBar: AppBar(
        elevation: 0.0,
        bottomOpacity: 0.0,
        backgroundColor: MyTheme.stripColor,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 15.0),
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
      drawer: navigationDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                        AppLocalization.of(context)
                                            .needASecureCar,
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
                                    Text(
                                        AppLocalization.of(context)
                                            .takeADeposit,
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
                                Icons.local_taxi,
                                color: Color(0xFAFFFFFF),
                                size: 40,
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
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalization.of(context).startingPoint,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: MyTheme.navBar,
                                    ),
                              ),
                              Text(
                                AppLocalization.of(context).required,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: MyTheme.navBar,
                                    ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _textControllerFrom,
                            cursorColor: MyTheme.primaryColor,
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey: kGoogleApiKey,   // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) {
                                      _textControllerFrom.text = result.name;
                                      print(result.adrAddress);
                                      Navigator.of(context).pop();
                                    },
                                    useCurrentLocation: true,
                                    initialPosition: kInitialPosition,
                                    selectInitialPosition: true,
                                    initialMapType: MapType.terrain,
                                  ),
                                ),
                              );
                            },
                            style: TextStyle(color: MyTheme.navBar, fontWeight: FontWeight.w400),
                            decoration: new InputDecoration(
                                prefixIcon: Icon(Icons.room, color: MyTheme.navBar, size: 18,),
                                suffixIcon: _showClearButtonInputFrom? IconButton(
                                  onPressed: () => _textControllerFrom.clear(),
                                  icon: Icon(Icons.clear, color: MyTheme.navBar, size: 16,),
                                ):null,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: MyTheme.primaryColor, width: 1.2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: MyTheme.navBar, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: MyTheme.navBar, width: 1),
                                ),

                                hintText: AppLocalization.of(context)
                                    .enterTheStartingPoint,
                                hintStyle: TextStyle(
                                    color: MyTheme.navBar,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalization.of(context).arrivalPoint,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: MyTheme.navBar,
                                    ),
                              ),
                              Text(
                                AppLocalization.of(context).required,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300,
                                      color: MyTheme.navBar,
                                    ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _textControllerTo,
                            cursorColor: MyTheme.primaryColor,
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                    apiKey: kGoogleApiKey,   // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) {
                                      _textControllerTo.text = result.name;
                                      print(result.adrAddress);
                                      Navigator.of(context).pop();
                                    },
                                    useCurrentLocation: true,
                                    initialPosition: kInitialPosition,
                                    selectInitialPosition: true,
                                    initialMapType: MapType.terrain,
                                  ),
                                ),
                              );
                            },
                            style: TextStyle(color: MyTheme.navBar, fontWeight: FontWeight.w400),
                            decoration: new InputDecoration(
                                prefixIcon: Icon(Icons.room, color: MyTheme.navBar, size: 18,),
                                suffixIcon: _showClearButtonInputTo? IconButton(
                                  onPressed: () => _textControllerTo.clear(),
                                  icon: Icon(Icons.clear, color: MyTheme.navBar, size: 16,),
                                ):null,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 10),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: MyTheme.primaryColor, width: 1.2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: MyTheme.navBar, width: 1),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.zero),
                                  borderSide: BorderSide(
                                      color: MyTheme.navBar, width: 1),
                                ),

                                hintText: AppLocalization.of(context)
                                    .enterTheArrivalPoint,
                                hintStyle: TextStyle(
                                    color: MyTheme.navBar,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //Button zone
          Row(
            children: [
              NavigationButton(
                backColor: Color(0xFA0c1117),
                textColor: Color(0xFAFFFFFF),
                icon: Icons.chevron_left,
                text: AppLocalization.of(context).previous,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/home',
                      arguments: <String, dynamic>{});
                },
              ),
              NavigationButton(
                backColor: MyTheme.primaryColor,
                textColor: Colors.black,
                icon: Icons.chevron_right,
                text: AppLocalization.of(context).next,
                onTap: () {
                  print("tapped next");
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}

Widget getButton() {
  return null;
}