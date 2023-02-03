import 'package:flutter/material.dart';
import 'package:radio_player/radio_player.dart';
import 'home_screen.dart';

class RadioPlayerScreen extends StatefulWidget {
  final RadioStation station;

  RadioPlayerScreen({required this.station});

  @override
  State<RadioPlayerScreen> createState() => _RadioPlayerScreenState();
}

void _goToHomeScreen(BuildContext context) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> {

  RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;

  void setIsPlaying(bool play){
    isPlaying = play;
  }

  @override
  void initState() {
    super.initState();

    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: widget.station.name,
      url: widget.station.url,
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Radio App',
      theme: ThemeData(),
      home: Scaffold (
        backgroundColor: Colors.blue.shade800,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            color: Colors.white,
            onPressed: () {
              _radioPlayer.stop();
              isPlaying = false;
              _goToHomeScreen(context);
            },
          ),
          elevation: 0.0,
          title: Text(
            'RADIO PLAYER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: "FuturaPT",
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue.shade800,
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: screenHeight*0.4,
              height: screenHeight*0.6,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    )
                  ]
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: screenHeight*0.2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: _radioPlayer.getArtworkImage(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      Image artwork;
                      if (snapshot.hasData){
                        artwork = Image.network(widget.station.favicon, fit: BoxFit.cover, width: 240, height: 240,);
                      } else {
                        artwork = Image.network(widget.station.favicon, fit: BoxFit.cover, width: 240, height: 240,);
                      }
                      return Container(
                        height: 240,
                        width: 240,
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: ClipRRect(
                            child: artwork,
                            borderRadius: BorderRadius.circular(8.0),
                          )
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 15,
                              offset: Offset(5, 5),
                            ),
                          ]
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 32),
                  Text(
                    widget.station.name,
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      fontFamily: "FuturaPT",
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: IconButton(
                      onPressed: () async {
                        isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
                      },
                      icon: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      ),
                      iconSize: 30,
                      color: Colors.white,
                      highlightColor: Colors.green.shade100,
                    ),
                  )
                ],
              ),
            ),
          ],
        )
      )
    );
  }
}