import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:tictactoe/Widgets/dialougebox.dart';
import 'package:tictactoe/Widgets/gameScore.dart';

int currentMoves = 0;
List<String> _board = ['', '', '', '', '', '', '', '', '']; //empty board
String status = '';
String winner = '';
var _gamePageState;
var _turnState;
var _context;
String _turn = 'First Move: X';
bool loading = false;
bool vsBot;

class GamePage extends StatefulWidget {
  bool isBot;
  GamePage(this.isBot) {
    _resetGame();
    vsBot = this.isBot;
    if (vsBot) _turn = 'First Move: O';
  }
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    _gamePageState = this;
    return _BoxContainer();
  }
}

class _BoxContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff1DB954),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 2.0,
              offset: Offset.zero)
        ],
      ),
      height: 265,
      width: MediaQuery.of(context).size.width * 0.675,
      child: GridView.count(
        physics: new NeverScrollableScrollPhysics(),
        primary: false,
        crossAxisCount: 3,
        children: List.generate(9, (index) {
          return Box(index);
        }),
      ),
    );
  }
}

class Box extends StatefulWidget {
  final int index;
  Box(this.index);
  @override
  _BoxState createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  Widget build(context) {
    return Container(
      child: MaterialButton(
          padding: EdgeInsets.all(0),
          child: Container(
              decoration: BoxDecoration(
                  // color: Colors.blue,
                  shape: BoxShape.rectangle,
                  border: new Border.all(color: Colors.black, width: 1)),
              child: Center(
                child: Text(
                  _board[widget.index].toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    color: _board[widget.index] == 'x'
                        ? Colors.black
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
          onPressed: () {
            if (_board[widget.index] == '') {
              // if not playing with bot
              if (vsBot == false) {
                if (currentMoves % 2 == 0)
                  _board[widget.index] = 'x';
                else
                  _board[widget.index] = 'o';
              }
              // playing with bot
              else if (!loading) {
                loading = true;
                _board[widget.index] = 'o';
                if (currentMoves >= 8) {
                } else
                  _bestMove(_board);
                setState(() {
                  currentMoves++;
                });
                //print(_board);
              }
              //print(vsBot);
              pressed();
            }
          }),
    );
  }

  void pressed() {
    print(currentMoves);
    setState(() {
      currentMoves++;
      if (_checkGame()) {
        awaitfnn('${winner.toUpperCase()} Won');
      } else if (currentMoves >= 9) {
        // awaitfn('It\'s a Draw', 'Want to try again?', 'Go Back', 'New Game');
        awaitfnn('Draw Match');
      }
    });
  }
}

//-------------------------------------Game func ---------------------------

bool _checkGame() {
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      (winner == 'x') ? Something.xScore += 1 : Something.oScore += 1;
      print(Something.oScore);
      print(Something.xScore);
      return true;
    }
  }
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      (winner == 'x') ? Something.xScore += 1 : Something.oScore += 1;
      print(Something.oScore);
      print(Something.xScore);
      return true;
    }
  }
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    (winner == 'x') ? Something.xScore += 1 : Something.oScore += 1;
    print(Something.oScore);
    print(Something.xScore);
    return true;
  }
  return false;
}

void _resetGame() {
  currentMoves = 0;
  status = '';
  _board = ['', '', '', '', '', '', '', '', ''];
  _turn = 'First Move: X';
  loading = false;
}

//------------------------------ Alerts Dialog --------------------------------------

void awaitfnn(title) async {
  bool result = await _showAlertBox(_context, title);
  if (result) {
    _gamePageState.setState(() {
      _resetGame();
    });
  } else {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}

Future<bool> _showAlertBox(BuildContext context, String title) async {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext _context) => DialougeBoxOfGame(
            title: title,
          ));
}

//------------------------------ MIN-MAX ------------------------------------------

int max(int a, int b) {
  return a > b ? a : b;
}

int min(int a, int b) {
  return a < b ? a : b;
}

String player = 'x', opponent = 'o';

bool isMovesLeft(List<String> _board) {
  int i;
  for (i = 0; i < 9; i++) {
    if (_board[i] == '') return true;
  }
  return false;
}

int _eval(List<String> _board) {
  //  rows check winning condition
  for (int i = 0; i < 9; i += 3) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 1] &&
        _board[i + 1] == _board[i + 2]) {
      winner = _board[i];
      return (winner == player) ? 10 : -10;
    }
  }

  // column check winning condition
  for (int i = 0; i < 3; i++) {
    if (_board[i] != '' &&
        _board[i] == _board[i + 3] &&
        _board[i + 3] == _board[i + 6]) {
      winner = _board[i];
      return (winner == player) ? 10 : -10;
    }
  }

  //  diaogonal winning condition
  if (_board[0] != '' && (_board[0] == _board[4] && _board[4] == _board[8]) ||
      (_board[2] != '' && _board[2] == _board[4] && _board[4] == _board[6])) {
    winner = _board[4];
    return (winner == player) ? 10 : -10;
  }
  return 0;
}

int minmax(List<String> _board, int depth, bool isMax) {
  int score = _eval(_board);
  //print(score);
  int best = 0, i;

  if (score == 10 || score == -10) return score;
  if (!isMovesLeft(_board)) return 0;
  if (isMax) {
    best = -1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = player;
        best = max(best, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    return best;
  } else {
    best = 1000;
    for (i = 0; i < 9; i++) {
      if (_board[i] == '') {
        _board[i] = opponent;
        best = min(best, minmax(_board, depth + 1, !isMax));
        _board[i] = '';
      }
    }
    //print(best);
    return best;
  }
}

int _bestMove(List<String> _board) {
  int bestMove = -1000, moveVal;
  int i, bi;
  for (i = 0; i < 9; i++) {
    if (_board[i] == '') {
      moveVal = -1000;
      _board[i] = player;
      moveVal = minmax(_board, 0, false);
      _board[i] = '';
      if (moveVal > bestMove) {
        bestMove = moveVal;
        bi = i;
      }
    }
  }
  _board[bi] = player;
  _gamePageState.setState(() {});
  loading = false;

  return bestMove;
}
