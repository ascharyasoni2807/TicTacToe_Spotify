import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tictactoe/Screens/startPage.dart';
import 'package:tictactoe/Screens/gamePage.dart';
import 'package:tictactoe/Widgets/spotify.dart';
import 'package:tictactoe/Widgets/gameBoard.dart';

Future<void> main() async {
  await load(fileName: '.env');
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        initialRoute: "/",
        routes: {
          "/": (context) => StartPage(),
          "/home": (context) => Myhome(),
       

          // "/player":(context)=>PLAYER(),
        });
  }
}
