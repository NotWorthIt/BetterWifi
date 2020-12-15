import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:logger/logger.dart';
import 'dart:ui' as UI;
import 'dart:typed_data';
import 'SideDrawer.dart';
import 'package:image/image.dart' as IMG;

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet connectivity',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: ScanPage(),
    );
  }
}

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class GpsPainter extends CustomPainter {
  var _repaint;
  UI.Image _image;

  GpsPainter({Listenable repaint}) : super(repaint: repaint) {
    _repaint = repaint;
  }

  void setImage(UI.Image image) {
    _image = image;
  }

  @override
  void paint(Canvas canvas, Size size) {
    /*
    var paint1 = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.fill;
                                   */
    double scale = 0.6;
    canvas.rotate(_repaint.value.toDouble() * math.pi / 180);
    canvas.scale(scale);
    double imageHeight = _image.height.toDouble();
    double offsetHeight = -imageHeight * 1 * scale;


    var paint1 = new Paint();
    paint1.color = Color.fromARGB(255, 255, 255, 255);
    if (_image != null) {
      canvas.drawImage(_image, Offset(offsetHeight, offsetHeight), paint1);
    }
    //canvas.drawRect(Offset(0, 0) & Size(50, 100), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

var logger = Logger();

class _ScanPageState extends State<ScanPage> {
  final gpsController = TextEditingController();
  Timer timerGps;
  GpsPainter painterGps;
  final valueGps = ValueNotifier<int>(0);

  final wifiController = TextEditingController();
  Timer timerWifi;

  final instructionsController = TextEditingController();

  UI.Image image;

  @override
  void initState() {
    super.initState();
    loadImage();
    timerGps = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateGPS());
    timerWifi = Timer.periodic(Duration(seconds: 1), (Timer t) => updateWifi());
    painterGps = GpsPainter(repaint: valueGps);
  }

  Future<UI.Image> loadUiImage(String imageAssetPath) async {
    final ByteData data = await rootBundle.load(imageAssetPath);
    final Completer<UI.Image> completer = Completer();
    UI.decodeImageFromList(Uint8List.view(data.buffer), (UI.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<void> loadImage() async {
    image = await loadUiImage("assets/heatmap.png");
    painterGps.setImage(image);
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
    instructionsController.text = "Move to first corner of your room";
  }

  void moveEast() {
    instructionsController.text = "Move to second corner of your room";
  }

  void moveSouth() {
    instructionsController.text = "Move to third corner of your room";
  }

  void moveWest() {
    instructionsController.text = "Move to fourth corner of your room";
  }

  bool scanActive = false;
  int pointCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Internet connectivity'),
        ),
        drawer: SideDrawer(), //this will just add the Navigation Drawer Icon
        body: Container(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
          Padding(padding: new EdgeInsets.all(10.0)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            FlatButton(
              color: Colors.grey,
              child: Text('Start scan'),
              onPressed: _startScan,
            ),
            Padding(padding: new EdgeInsets.all(10.0)),
            RaisedButton(
              color: Colors.grey,
              child: Text('Set point'),
              onPressed: _setScan,
            ),
            Padding(padding: new EdgeInsets.all(10.0)),
            RaisedButton(
              color: Colors.grey,
              child: Text('Finish scan'),
              onPressed: _stopScan,
            ),
          ]),
          TextFormField(
            key: Key('wifi'),
            readOnly: true,
            controller: wifiController,
            decoration: InputDecoration(labelText: 'wifi'),
          ),
          TextFormField(
            key: Key('gps'),
            readOnly: true,
            controller: gpsController,
            decoration: InputDecoration(labelText: 'gps'),
          ),
          TextFormField(
            key: Key('instructions'),
            readOnly: true,
            controller: instructionsController,
            decoration: InputDecoration(labelText: 'instructions'),
          ),
          Padding(padding: new EdgeInsets.all(100.0)),
          CustomPaint(
            painter: painterGps,
          ),
        ]))));
  }

  _startScan() async {
    moveNorth();
    scanActive = true;
    pointCounter = 1;
  }

  _setScan() async {
    if (scanActive) {
      if (pointCounter == 1) {
        moveEast();
        pointCounter++;
      } else if (pointCounter == 2) {
        moveSouth();
        pointCounter++;
      } else if (pointCounter == 3) {
        moveWest();
        pointCounter++;
      } else if (pointCounter == 4) {
        _showDialog("Finished scan", "All Points have been scanned");
        scanActive = false;
        pointCounter = 0;
      }
    }
  }

  _stopScan() async {
    if (scanActive == true) {
      _showDialog("Finished scan", "All Points have been scanned");
      scanActive = false;
      pointCounter = 0;
    }
    //_showDialog("Scan sopped", "TODO");
  }

  _checkInternetConnectivity() async {
    WifiInfoWrapper wifiObject;
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
      var tmp = await FlutterCompass.events.first;
      String result = "Network: " + wifiObject.signalStrength.toString() + " GPS: " + tmp.toString();
      _showDialog("signal strength", result);
    } on MissingPluginException {
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
