import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_button.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/widgets/card_button.dart';
import 'package:kifcab/utils/Utils.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/src/core.dart';
import 'dart:async';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

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
  String _kGoogleApiKey = GOOGLE_API_KEY;
  final TextEditingController _textControllerFrom = new TextEditingController();
  final TextEditingController _textControllerTo = new TextEditingController();
  bool _showClearButtonInputFrom = false;
  bool _showClearButtonInputTo = false;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  Location _fromLocation = null;
  Location _toLocation = null;
  final __textFieldFromFocusNode = FocusNode();
  final _textFieldToFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _step = 0;
  Completer<GoogleMapController> _controllerMap = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  int _selectedRange = 0;
  int _selectedPayment = 0;

  Future<void> _goToTheLake() async {
    _controllerMap = Completer();
    CameraPosition _myLkLake = CameraPosition(
        bearing: 0.8334901395799,
        //bearing: 192.8334901395799,
        target: LatLng(_fromLocation.lat, _fromLocation.lng),
        tilt: 0,
        //tilt: 59.440717697143555,
        zoom: 14.4746);
    final GoogleMapController controller = await _controllerMap.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_myLkLake));
  }

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
      key: _scaffoldKey,
      backgroundColor: MyTheme.stripColor,
      appBar: PreferredSize(
        child: Container(
          color: Colors.transparent,
          // color: MyTheme.primaryDarkColor,
        ),
        preferredSize: Size(0.0, 0.0),
      ),
      drawer: navigationDrawer(),
      body: Column(
        children: [
          if (_step == 0)
            Column(
              children: [
                Container(
                  color: MyTheme.stripColor,
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
                SizedBox(
                  height: 10,
                ),
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
                                Text(AppLocalization.of(context).needASecureCar,
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
                                Text(AppLocalization.of(context).takeADeposit,
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
                  height: 5,
                ),
              ],
            ),
          if (_step == 0)
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),

                      //_step1
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                              focusNode: __textFieldFromFocusNode,
                              onTap: () {
                                if (__textFieldFromFocusNode.canRequestFocus) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlacePicker(
                                        apiKey: _kGoogleApiKey,
                                        // Put YOUR OWN KEY here.
                                        onPlacePicked: (result) {
                                          setState(() {
                                            _fromLocation =
                                                result.geometry.location;
                                          });
                                          print(result.geometry.location.lat);
                                          print(result.geometry.location.lng);
                                          _textControllerFrom.text =
                                              result.formattedAddress;
                                          Navigator.of(context).pop();
                                        },
                                        autocompleteLanguage: "fr",
                                        useCurrentLocation: true,
                                        initialPosition: kInitialPosition,
                                        initialMapType: MapType.normal,
                                        selectInitialPosition: true,
                                        searchingText: "Recherche en cours....",
                                        hintText:
                                            "Rechercher un emplacement...",
                                      ),
                                    ),
                                  );
                                }
                              },
                              autofocus: false,
                              readOnly: true,
                              style: TextStyle(
                                  color: MyTheme.navBar,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.room,
                                    color: MyTheme.navBar,
                                    size: 18,
                                  ),
                                  suffixIcon: _showClearButtonInputFrom
                                      ? IconButton(
                                          onPressed: () {
                                            __textFieldFromFocusNode.unfocus();
                                            __textFieldFromFocusNode
                                                .canRequestFocus = false;
                                            _textControllerFrom.clear();
                                            _fromLocation = null;
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: MyTheme.navBar,
                                            size: 16,
                                          ),
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.primaryColor,
                                        width: 1.2),
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
                            if (_fromLocation != null)
                              Text(
                                _fromLocation.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: MyTheme.navBar,
                                    ),
                              )
                          ],
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                              focusNode: _textFieldToFocusNode,
                              onTap: () {
                                if (_textFieldToFocusNode.canRequestFocus) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlacePicker(
                                        apiKey:
                                            _kGoogleApiKey, // Put YOUR OWN KEY here.
                                        onPlacePicked: (result) {
                                          setState(() {
                                            _toLocation =
                                                result.geometry.location;
                                          });
                                          print(result.geometry.location.lat);
                                          print(result.geometry.location.lng);
                                          _textControllerTo.text =
                                              result.formattedAddress;
                                          Navigator.of(context).pop();
                                        },
                                        useCurrentLocation: true,
                                        initialPosition: _toLocation != null
                                            ? LatLng(_toLocation.lat,
                                                _toLocation.lng)
                                            : kInitialPosition,
                                        initialMapType: MapType.normal,
                                        selectInitialPosition: true,
                                      ),
                                    ),
                                  );
                                }
                              },
                              autofocus: false,
                              readOnly: true,
                              style: TextStyle(
                                  color: MyTheme.navBar,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.room,
                                    color: MyTheme.navBar,
                                    size: 18,
                                  ),
                                  suffixIcon: _showClearButtonInputTo
                                      ? IconButton(
                                          onPressed: () {
                                            _textFieldToFocusNode.unfocus();
                                            _textFieldToFocusNode
                                                .canRequestFocus = false;
                                            _textControllerTo.clear();
                                            _toLocation = null;
                                          },
                                          icon: Icon(
                                            Icons.clear,
                                            color: MyTheme.navBar,
                                            size: 16,
                                          ),
                                        )
                                      : null,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: MyTheme.primaryColor,
                                        width: 1.2),
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
                            if (_toLocation != null)
                              Text(
                                _toLocation.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: MyTheme.navBar,
                                    ),
                              )
                          ],
                        ),
                      ),
                      //_step2
                    ],
                  ),
                ),
              ),
            ),

          if (_step == 1)
            Stack(
              children: [
                Container(
                  height: 260,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: GoogleMap(
                    // myLocationEnabled: true,

                    initialCameraPosition: _kGooglePlex,

                    onMapCreated: (GoogleMapController controller) {
                      if (!_controllerMap.isCompleted)
                        _controllerMap.complete(controller);
                    },
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 50,
                    child: Row(
                      children: [
                        Container(
                          color: Colors.black,
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          child: Text(
                            AppLocalization.of(context).deposit,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding:
                              EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                          child: Text(
                            "/",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
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
                ),
              ],
            ),

          if (_step == 1)
            Expanded(
                child: Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Column(children: [
                          SizedBox(
                            height: 130,
                            child: TextFormField(
                              minLines: 2,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(
                                  color: MyTheme.navBar,
                                  fontWeight: FontWeight.w400),
                              decoration: new InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      top: 20.0, left: 15, right: 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1.2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                    borderSide: BorderSide(
                                        color: Colors.transparent, width: 1),
                                  ),
                                  hintText: AppLocalization.of(context)
                                      .messageToSendToTheDriver,
                                  hintStyle: TextStyle(
                                      color: MyTheme.navBar,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14)),
                            ),
                          ),
                          Container(
                            height: 250,
                            //color:Color(0xFFF1F1F1),
                            padding: EdgeInsets.all(0),
                            child: ContainedTabBarView(
                              tabs: [
                                Text(AppLocalization.of(context).ranges,
                                    style: TextStyle(
                                        color: MyTheme.navBar,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                                Text(AppLocalization.of(context).payment,
                                    style: TextStyle(
                                        color: MyTheme.navBar,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14))
                              ],
                              tabBarProperties: TabBarProperties(
                                  height: 32.0,
                                  indicatorColor: MyTheme.primaryColor,
                                  indicatorWeight: 2.5,
                                  labelColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  unselectedLabelColor: Colors.grey[400]),
                              views: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  color: Colors.transparent,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      CardButton(index: 0, selectedIndex: _selectedRange,imageUrl: 'assets/2.png',isAsset: true,text: "Classe Bronze",onTap: (){
                                        print("Tap elemen");
                                        setState(() {
                                          _selectedRange = 0;
                                        });
                                      },),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CardButton(index: 1, selectedIndex: _selectedRange,imageUrl: 'assets/3.png',isAsset: true,text: "Classe Argent",onTap: (){
                                        print("Tap elemen");
                                        setState(() {
                                          _selectedRange = 1;
                                        });
                                      },),

                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  color: Colors.transparent,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: <Widget>[

                                      CardButton(index: 0, selectedIndex: _selectedPayment,imageUrl: 'assets/cash.png',isAsset: true,text: "Cash",onTap: (){
                                        print("Tap elemen");
                                        setState(() {
                                          _selectedPayment = 0;
                                        });
                                      },),

                                      SizedBox(
                                        width: 10,
                                      ),
                                      CardButton(index: 1, selectedIndex: _selectedPayment,imageUrl: 'assets/om.jpg',isAsset: true,text: "Orange",onTap: (){
                                        print("Tap elemen");
                                        setState(() {
                                          _selectedPayment = 1;
                                        });
                                      },),

                                      SizedBox(
                                        width: 10,
                                      ),
                                      CardButton(index: 2, selectedIndex: _selectedPayment,imageUrl: 'assets/mo.jpg',isAsset: true,text: "MTN",onTap: (){
                                        print("Tap elemen");
                                        setState(() {
                                          _selectedPayment = 2;
                                        });
                                      },),

                                    ],
                                  ),
                                ),
                              ],
                              onChange: (index) => print(index),
                            ),
                          ),
                        ])))),
          //Button zone
          Row(
            children: [
              NavigationButton(
                backColor: Color(0xFA0c1117),
                textColor: Color(0xFAFFFFFF),
                icon: Icons.chevron_left,
                text: AppLocalization.of(context).previous,
                onTap: () {
                  if (_step == 0) {
                    Navigator.pushReplacementNamed(context, '/home',
                        arguments: <String, dynamic>{});
                  } else {
                    this.setState(() {
                      _step--;
                    });
                  }
                },
              ),
              NavigationButton(
                backColor: MyTheme.primaryColor,
                textColor: Colors.black,
                icon: (_step == 1)?Icons.check:Icons.chevron_right,
                text: (_step == 1)? AppLocalization.of(context).save: AppLocalization.of(context).next,
                onTap: () {
                  if (_step == 1) {
                    print("Valider");
                  } else {
                    _goToTheLake();
                    this.setState(() {
                      _step++;
                    });
                  }
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
