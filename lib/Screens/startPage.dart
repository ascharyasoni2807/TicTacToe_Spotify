import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tictactoe/Screens/gamePage.dart';
import 'package:tictactoe/Widgets/gameBoard.dart';

class StartPage extends StatelessWidget {
  static var fontdesign = GoogleFonts.lemonada(
      textStyle:
          TextStyle(color: Colors.white, letterSpacing: 3, fontSize: 15));
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
          color: Color(0xff1DB954),
          child: Column(children: <Widget>[
            SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/img.png'),
                        fit: BoxFit.fill,
                      ),
                    ))),
            SizedBox(height: 40),
            RaisedButton(
                splashColor: Colors.green,
                color: Colors.black,
                child: Text('PLAY GAME VS AI', style: fontdesign),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Myhome(isBot: true)));
                }),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
                splashColor: Colors.green,
                color: Colors.black,
                child: Text('PLAY GAME VS FRIEND', style: fontdesign),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => Myhome(isBot: false)));
                })
          ])),
    );
  }
}
