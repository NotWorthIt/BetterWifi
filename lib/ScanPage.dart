import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:logger/logger.dart';
import 'package:wifi_tool/scanHistory.dart';

import 'drawer.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet connectivity',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class GpsPainter extends CustomPainter {
  var _repaint;
  GpsPainter({Listenable repaint}) : super(repaint: repaint){
    _repaint = repaint;
  }
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.fill;

    canvas.rotate(_repaint.value.toDouble()*math.pi/180);

    canvas.drawRect(Offset(0, 0) & Size(50,100), paint1);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
var logger = Logger();
class _HomePageState extends State<HomePage> {
  final gpsController = TextEditingController();
  Timer timerGps;
  GpsPainter painterGps;
  final valueGps = ValueNotifier<int>(0);

  final wifiController = TextEditingController();
  Timer timerWifi;

  final instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timerGps = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateGPS());
    timerWifi = Timer.periodic(Duration(seconds: 1), (Timer t) => updateWifi());
    painterGps = GpsPainter(repaint: valueGps);
  }

  Future<void> updateGPS() async {
    var tmp = await FlutterCompass.events.first;
    gpsController.text = tmp.toString();
    valueGps.value = tmp.toInt();
  }

  Future<void> updateWifi() async {
    var tmp = await WifiInfoPlugin.wifiDetails;
    wifiController.text = tmp.signalStrength.toString();
  }

  void moveNorth() {
    instructionsController.text = "Move north";
  }

  void moveEast() {
    instructionsController.text = "Move east";
  }

  void moveSouth() {
    instructionsController.text = "Move south";
  }

  void moveWest() {
    instructionsController.text = "Move west";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Internet connectivity'),
        ),
        drawer: SideDrawer(),//this will just add the Navigation Drawer Icon
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          RaisedButton(
            child: Text('Check sensor data(Debug)'),
            onPressed: _checkInternetConnectivity,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            RaisedButton(
              child: Text('Start scan'),
              onPressed: _startScan,
            ),
            RaisedButton(
              child: Text('Set scan'),
              onPressed: _setScan,
            ),
            RaisedButton(
              child: Text('Finish scan'),
              onPressed: _stopScan,
            ),
          ]),
          TextFormField(
            key: Key('wifi'),
            controller: wifiController,
            decoration: InputDecoration(labelText: 'wifi'),
          ),
          TextFormField(
            key: Key('gps'),
            controller: gpsController,
            decoration: InputDecoration(labelText: 'gps'),
          ),
          TextFormField(
            key: Key('instructions'),
            controller: instructionsController,
            decoration: InputDecoration(labelText: 'instructions'),
          ),
          CustomPaint(
            painter: painterGps,
          ),
        ]))));
  }

  _startScan() async{
    _showDialog("Scan started", "TODO");
  }
  _setScan() async{
    _showDialog("Point set", "TODO");
  }

  _stopScan() async{
    _showDialog("Scan sopped", "TODO");
  }

  _checkInternetConnectivity() async {
    WifiInfoWrapper wifiObject;
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
      var tmp = await FlutterCompass.events.first;
      String result = "Network: " + wifiObject.signalStrength.toString() + " GPS: " + tmp.toString();
      _showDialog("signal strength", result);
    } on MissingPluginException{
      _showDialog("Platform not support", "");
    }
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
