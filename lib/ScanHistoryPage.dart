import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wifi_tool/ScanDetailPage.dart';
import 'package:wifi_tool/SideDrawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vector_math/vector_math.dart';


class ScanHistory extends StatefulWidget {
  @override
  _ScanHistory createState() => _ScanHistory();
}

class Data {
  DateTime time;

  //first two numbers are coordinates, 3rd number is signal strength
  List<Vector2> coordinates = <Vector2>[];
  List<int> strengths = <int>[];

  Data(DateTime time, List<Vector2> coordinates, List<int> strengths){
    this.time = time;
    this.coordinates = coordinates;
    this.strengths = strengths;
  }
  Data.fromJson(Map<String, dynamic> json)
      : time = DateTime.parse(json['time']),
       coordinates = fromJsonCoordinates(json['coordinates']),
       strengths = fromJsonStrengths(json['strengths']);

  Map<String, dynamic> toJson() => {
    'time': time.toIso8601String(),
    'coordinates': coordinates.map((e) => '[' + e.g.toString() + ',' + e.r.toString()  + ']').toList(),
    'strengths': strengths.map((e) => e.toString()).toList(),
  };

  String toString(){
    return time.day.toString() + "." + time.month.toString() + "." +
        time.year.toString() + " " + time.hour.toString() + ":" + time.minute.toString();
  }
}

List<Vector2> fromJsonCoordinates(List<dynamic> jsonList){
  List<Vector2> list = <Vector2>[];
  for(var ele in jsonList){
    String s = ele.toString();
    list.add(new Vector2(double.parse(s.split(",")[0].substring(1)),double.parse(s.split(",")[1].substring(0, s.split(",")[1].length - 1))));
  }
  return list;
}

List<int> fromJsonStrengths(List<dynamic> stringList){
  List<int> list = <int>[];
  for(var ele in stringList){
   list.add(int.parse(ele));
  }
  return list;
}

Future delDB() async{
  var prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future addData(List<Vector2> coordinates, List<int> strengths) async{
  //await delDB();
  var prefs = await SharedPreferences.getInstance();
  //get all data
  if(prefs.getString('data') != null) {
    var dec = json.decode(prefs.getString('data'));
    List<Data> list = <Data>[];
    for (int i = 0; i < dec.length; i++) {
      list.add(Data.fromJson(dec[i]));
    }
    list.add(new Data(new DateTime.now(), coordinates, strengths));

    prefs.setString('data', json.encode(list));
  }else{
    List<Data> list = <Data>[];
    list.add(new Data(new DateTime.now(), coordinates, strengths));
    prefs.setString('data', json.encode(list));
  }
}

class _ScanHistory extends State<ScanHistory> {

  final _biggerFont = TextStyle(fontSize: 18.0);
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Scan history'),
      ),
      drawer: SideDrawer(),
      body: Container(
          child: FutureBuilder(
              builder: (context, dataSnap) {
                if (dataSnap.data == null) {
                  return Container();
                }
                return ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: dataSnap.data.length*2,
                    itemBuilder: (context, i) {
                      if (i.isOdd) return Divider();
                      final index = i ~/ 2;
                      return _buildRow(dataSnap.data[index]);

                    }
                );

              },
              future: readData(),
          ),

      ),
    );
  }



  Future readData() async{
    var prefs = await SharedPreferences.getInstance();
    var dec = json.decode(prefs.getString('data'));
    List<Data> decodedList = <Data>[];
    for(int i = 0; i < dec.length; i++){
      Data.fromJson(dec[i]);
      decodedList.add(Data.fromJson(dec[i]));
    }
    return decodedList;
  }

  Widget _buildRow(Data data) {
    return ListTile(
      title: Text(
        data.toString(),
        style: _biggerFont,
      ),
      onTap: () {
        //_showDialog(data.toString() + " " + data.coordinates.toString() + " " + data.strengths.toString(), "TODO go to scan");


        Navigator.push(context, MaterialPageRoute(builder: (context) => ScanDetailPage(data)),);

      },
    );
  }
  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}