import 'package:flutter/material.dart';
import 'package:kifcab/utils/colors.dart';
import 'package:kifcab/locale/app_localization.dart';

int note = 0;

class Note {
  static loadSubmit(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        color: Color.fromRGBO(0, 0, 0, 0.2),
      ),
      child: Center(
        child: Align(
            alignment: Alignment.center,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              Container(
                child: Text(
                  "Opération terminée",
                  style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(
                  "Afin d'optimiser notre plateforme pour mieux vous servir, merci de noter le client",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(50, 25, 50, 25),
                child: Row(
                  children: [
                    note < 1
                        ? InkWell(
                            onTap: () {
                              print("ok");
                              note = 1;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoile.png',
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              note = 1;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoilej.png',
                              ),
                            ),
                          ),
                    note < 2
                        ? InkWell(
                            onTap: () {
                              note = 2;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoile.png',
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              note = 2;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoilej.png',
                              ),
                            ),
                          ),
                    note < 3
                        ? InkWell(
                            onTap: () {
                              note = 3;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoile.png',
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              note = 3;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoilej.png',
                              ),
                            ),
                          ),
                    note < 4
                        ? InkWell(
                            onTap: () {
                              note = 4;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoile.png',
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              note = 4;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoilej.png',
                              ),
                            ),
                          ),
                    note < 5
                        ? InkWell(
                            onTap: () {
                              note = 5;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoile.png',
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              note = 5;
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              width: MediaQuery.of(context).size.width / 5 - 20,
                              child: Image.asset(
                                'assets/etoilej.png',
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Text(
                  note.toString() + "  / 5",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.normal),
                ),
              ),
              Container(
                width: 220,
                padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: RaisedButton(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  onPressed: () async {
                    /*  log("validdate pressed");
                                                        setState(() {
                                                          visible = true;
                                                        });
                                                        HttpPostRequest.validateCommande(
                                                                globals
                                                                    .userinfos
                                                                    .id_compte,
                                                                globals
                                                                    .commande[
                                                                        "cout"]
                                                                    .toString(),
                                                                "30",
                                                                globals
                                                                    .commande[
                                                                        "id_commande"]
                                                                    .toString(),
                                                                globals
                                                                    .commande[
                                                                        "type"]
                                                                    .toString(),
                                                                "1")
                                                            .then((String
                                                                result) async {
                                                          setState(() {
                                                            visible = false;
                                                          });
                                                          log("offert");
                                                          if (result ==
                                                              "error") {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Une erreur s'est produite verifier votre connexion",
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                                backgroundColor:
                                                                    Colors.red,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          } else {
                                                            setState(() {
                                                              globals.active =
                                                                  "2";
                                                            });
                                                          }
                                                          log(result);
                                                        });*/
                  },
                  color: MyTheme.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          //color: Color.fromRGBO(229, 188, 1, 1),

                          width: 5,
                          height: 40,
                          child: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Noter",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              /*  Padding(
                    padding: EdgeInsets.only(bottom: 35.0),
                    child: Text(
                      AppLocalization.of(context).wait,
                      style: Theme.of(context).textTheme.headline6.copyWith(
                          color: MyTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                    ),
                  ),
                  Image.asset('assets/load.gif', height: 80),*/
            ])),
      ),
    );
  }
}
