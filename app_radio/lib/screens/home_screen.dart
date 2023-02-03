import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'radio_player_screen.dart';

class RadioStation {
  String stationuuid;
  String name;
  String url;
  String favicon;

  RadioStation(this.stationuuid, this.name, this.url, this.favicon);

  RadioStation.fromJson(Map<String, dynamic> json)
    : this.stationuuid = json['stationuuid'],
      this.name = json['name'],
      this.url = json['url'],
      this.favicon = json['favicon'];
}

List<RadioStation> stationsList = [];

class HomeScreen extends StatefulWidget {
  HomeScreen(); 

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

  void _goToRadioPlayerScreen(BuildContext context, RadioStation station) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => RadioPlayerScreen(station: station),
      ),
    );
  }


class _HomeScreenState extends State<HomeScreen> {

  Future<List<RadioStation>> getStations() async {
    
    var text = await rootBundle.loadString("data/radioStations.json");
    var json = jsonDecode(text);
    for (var stationJson in json) {
      stationsList.add(RadioStation.fromJson(stationJson));
    }
    return stationsList;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radio App',
      theme: ThemeData(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'RADIO STATIONS LIST',
            style: TextStyle(
              fontFamily: "FuturaPT",
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white60,
          elevation: 0.0,
        ),
        body: FutureBuilder(
          future: getStations(),
          builder: (context, AsyncSnapshot<List> snapshot){
            if(snapshot.hasError){
              return Center(child: Text("Error: ${snapshot.error.toString()}"),);
            }
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return GridView.builder(
              itemCount: stationsList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0,
                mainAxisSpacing: 10.0
              ),
              itemBuilder: (context, index) {
                RadioStation station = stationsList[index];
                return ListTile(
                  onTap:(){_goToRadioPlayerScreen(context, station);},
                  title: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 2
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          offset: Offset(4, 4),
                          blurRadius: 4,
                        )
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 90,
                          width: 90,
                          child: ClipRRect(
                            child: Image.network(station.favicon, width: 90),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          station.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "FuturaPT",
                            fontSize: 18,
                          )
                        ),
                      ],
                    )
                  ),
                );
              }
            );
          }
        ),
      )
    );
  }
}