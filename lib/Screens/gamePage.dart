import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/Widgets/dialougebox.dart';
import 'package:tictactoe/Widgets/gameBoard.dart';
import 'package:tictactoe/Widgets/gameScore.dart';
import 'package:tictactoe/Widgets/spotify.dart';

class Myhome extends StatefulWidget {
  var isBot;
  Myhome({this.isBot});

  @override
  _MyhomeState createState() => _MyhomeState();
}

class _MyhomeState extends State<Myhome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Color(0xff1DB954),
              title: Text("XO GAME",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showScorePage();
                    })
              ],
            ),
            body: Container(
              child: Column(
                children: <Widget>[
                  // SizedBox(height: 20),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                      shadowColor: Colors.black,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        padding: EdgeInsets.all(8),
                        child: Spotifypage(),
                      ),
                    ),
                  )),
                  Expanded(
                    child: Center(
                        child: Container(child: GamePage(widget.isBot))),
                  )
                ],
              ),
            )));
  }

  void showScorePage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return GameScore();
        });
  }
}
