import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_context.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:tictactoe/Widgets/sized_icon_button.dart';

class Spotifypage extends StatefulWidget {
  @override
  _SpotifypageState createState() => _SpotifypageState();
}

class _SpotifypageState extends State<Spotifypage> {
  bool _loading = false;
  bool _connected = true;
  final Logger _logger = Logger();
  bool _loggedIn = false;
  var fontDesign =
      TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12);
  CrossfadeState crossfadeState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
              body: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _sampleFlowWidget(context)));
        },
      ),
    );
  }

  Widget _sampleFlowWidget(BuildContext context2) {
    return Stack(
      children: [
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  TextButton(
                    onPressed: _connected
                        ? () {
                            print('nill');
                          }
                        : connectToSpotifyRemote,
                    child: const Icon(
                      Icons.settings_remote,
                      color: Colors.green,
                    ),
                  ),
                  Text('Press Icon to Play', style: fontDesign)
                ],
              ),
              TextButton(
                  onPressed: getAuthenticationToken,
                  child: !_connected
                      ? Text('Log in  to Spotify', style: fontDesign)
                      : IconButton(
                          onPressed: disconnect,
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.green,
                          ),
                        )),
            ],
          ),
          const Divider(),
          _connected
              ? Text('Connection Status: Connected', style: fontDesign)
              : Text('Connection Status: Not Connected', style: fontDesign),
          _connected ? playerStateWidget() : Container()
        ]),
        _loading
            ? Container(
                // color: Colors.black12,
                child: const Center(
                    child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              )))
            : const SizedBox(),
      ],
    );
  }

  Widget playerStateWidget() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (BuildContext context, AsyncSnapshot<PlayerState> snapshot) {
        var track = snapshot.data?.track;
        var playerState = snapshot.data;

        if (playerState == null || track == null) {
          return Center(
            child: Container(),
          );
        }
        print('${track.imageUri.raw.length}');

        return Card(
          color: Color(0xff1DB954),
          elevation: 5,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.all(2),
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.95,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            ''' Title:  ${track.name} \n by:     ${track.artist.name}'''),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedIconButton(
                              width: 50,
                              icon: Icons.skip_previous,
                              onPressed: skipPrevious,
                            ),
                            SizedIconButton(
                              width: 50,
                              icon: Icons.play_arrow,
                              onPressed: resume,
                            ),
                            SizedIconButton(
                              width: 50,
                              icon: Icons.pause,
                              onPressed: pause,
                            ),
                            SizedIconButton(
                              width: 50,
                              icon: Icons.skip_next,
                              onPressed: skipNext,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedIconButton(
                              width: 50,
                              icon: Icons.queue_music,
                              onPressed: queue,
                            ),
                            SizedIconButton(
                              width: 50,
                              icon: Icons.repeat,
                              onPressed: toggleRepeat,
                            ),
                            SizedIconButton(
                              width: 50,
                              icon: Icons.shuffle,
                              onPressed: toggleShuffle,
                            ),
                            SizedIconButton(
                              width: 50,
                              icon: Icons.favorite,
                              onPressed: addToLibrary,
                            ),
                          ],
                        ),

                        const Divider(),
                        // Text('Image URI: ${track.imageUri.raw}'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //  SPOTIFY SDK FUNCTIONS TO CONTROLL

  Future<void> disconnect() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.disconnect();
      setStatus(result ? 'disconnect successful' : 'disconnect failed');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Spotify App disconnected"),
      ));
      setState(() {
        _loading = false;
        _loggedIn = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      setState(() {
        _loading = true;
      });
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: env['CLIENT_ID'].toString(),
          redirectUrl: env['REDIRECT_URL'].toString());
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(result
            ? 'connect to spotify successful'
            : 'connect to spotify failed'),
      ));
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      setState(() {
        _loading = false;
      });
    } on PlatformException catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("No Spotify App Found"),
      ));
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setState(() {
        _loading = false;
      });
      setStatus('not implemented');
    }
  }

  Future<String> getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: env['CLIENT_ID'].toString(),
          redirectUrl: env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      setState(() {
        _loggedIn = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Logged in success"),
      ));
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  Future getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> queue() async {
    try {
      await SpotifySdk.queue(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setRepeatMode(RepeatMode repeatMode) async {
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: repeatMode,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> setShuffle(bool shuffle) async {
    try {
      await SpotifySdk.setShuffle(
        shuffle: shuffle,
      );
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo() async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative() async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: 20000);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> addToLibrary() async {
    try {
      await SpotifySdk.addToLibrary(
          spotifyUri: 'spotify:track:58kNJana4w5BIjlZE2wq5m');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
