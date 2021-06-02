import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class Something {
  static int oScore = 0;
  static int xScore = 0;
}

class GameScore extends StatelessWidget {
  var fontdesign = GoogleFonts.lemonada(
      textStyle: TextStyle(
          color: Colors.black,
          letterSpacing: 3,
          fontSize: 12,
          fontWeight: FontWeight.bold));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          padding: EdgeInsets.all(10),
          child: Card(
              color: Colors.green,
              shadowColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              // color: Colors.black,
              elevation: 2,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Score',
                    style: fontdesign,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Player O',
                              style: fontdesign,
                            ),
                            Text(
                              Something.oScore.toString(),
                              style: fontdesign,
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Player X',
                              style: fontdesign,
                            ),
                            Text(
                              Something.xScore.toString(),
                              style: fontdesign,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          // Writing directly here
                          '''Rules :
1. The game is played on a grid that's 3 squares by 3 squares.

2. You are X, your friend (or the computer in this case) is O. Players take turns putting their marks in empty squares.

3. The first player to get 3 of her marks in a row (up, down, across, or diagonally) is the winner.

4. When all 9 squares are full, the game is over. If no player has 3 marks in a row, the game ends in a tie.
                        
                        ''',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
