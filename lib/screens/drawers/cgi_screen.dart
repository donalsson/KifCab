import 'package:flutter/material.dart';
import 'package:kifcab/constant.dart';
import 'package:kifcab/locale/app_localization.dart';
import 'package:kifcab/widgets/navigation_drawer.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:flutter_autolink_text/flutter_autolink_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class CgiScreen extends StatefulWidget {
  CgiScreen({
    Key key,
  }) : super(key: key);

  @override
  CgiScreenState createState() {
    return CgiScreenState();
  }
}

class CgiScreenState extends State<CgiScreen> {
  CgiScreenState();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final Completer<WebViewController> _controllerWebview =
      Completer<WebViewController>();
  String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

  }

  @override
  void dispose() {
    super.dispose();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
  void _showHtml( WebViewController controller, BuildContext context) async {
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    await controller.loadUrl('data:text/html;base64,$contentBase64');
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
              //physics: AlwaysScrollableScrollPhysics(),
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      //color: MyTheme.stripColor,
                      image: DecorationImage(
                        image: AssetImage("assets/pictures/2.jpg"),
                        colorFilter: ColorFilter.mode(
                            Color.fromRGBO(0, 0, 0, 0.7), BlendMode.darken),
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
                                  Text(AppLocalization.of(context).cgi,
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
                                  Text(AppLocalization.of(context).privacyPolicies,
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
                              Icons.privacy_tip,
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
                    height: MediaQuery.of(context).size.height - 150,

                    padding: EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                    child: WebView(
                        //initialUrl: 'https://www.google.com',

                        javascriptMode: JavascriptMode.unrestricted,
                        onWebViewCreated:(WebViewController webViewController) {
                          print("Finish create webview");
                          _onNavigationDelegateExample(webViewController,context);

                          _controllerWebview.complete(webViewController);

                        },
                        // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                        // ignore: prefer_collection_literals
                        javascriptChannels: <JavascriptChannel>[
                          _toasterJavascriptChannel(context),
                        ].toSet(),
                        navigationDelegate: (NavigationRequest request) {
                          if (request.url
                              .startsWith('https://www.youtube.com/')) {
                            print('blocking navigation to $request}');
                            return NavigationDecision.prevent;
                          }
                          print('allowing navigation to $request');
                          return NavigationDecision.navigate;
                        },
                        onPageStarted: (String url) {
                          print('Page started loading: $url');
                        },
                        onPageFinished: (String url) {
                          print('Page finished loading: $url');
                        },
                        gestureNavigationEnabled: true,

                    ),
                  ),

                  //_step2
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
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
          )
        ],
      ),
    );
  }
  void _onNavigationDelegateExample(
      WebViewController controller, BuildContext context) async {
    print("Load html content");
    String fileText = await rootBundle.loadString('assets/cgi.html');
    await controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());

    /*final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(kNavigationExamplePage));
    await controller.loadUrl('data:text/html;base64,$contentBase64');*/
  }
}
