import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DialougeBoxOfGame extends StatelessWidget {
  // const DialougeBoxOfGame({Key key}) : super(key: key);
  final title;
  final Function callBack;

  DialougeBoxOfGame({
    this.title,
    this.callBack,
  });

  static var fontdesignn = GoogleFonts.lemonada(
      textStyle: TextStyle(
          color: Colors.white,
          letterSpacing: 1,
          fontSize: 10,
          fontWeight: FontWeight.bold));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Color(0xff1DB954),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 120,
                padding: EdgeInsets.all(12),
                child: (RaisedButton(
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('PLAY AGIAN', style: fontdesignn))),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: RaisedButton(
                    color: Colors.black,
                    onPressed: () {
                      exit(0);
                    },
                    child: Text('EXIT', style: fontdesignn)),
              )
            ],
          )
        ]);
  }
}
