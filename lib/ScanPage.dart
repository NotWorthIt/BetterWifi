import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:logger/logger.dart';
import 'package:wifi_tool/ScanHistoryPage.dart';
import 'dart:ui' as UI;
import 'dart:typed_data';
import 'SideDrawer.dart';
import 'package:interpolate/interpolate.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

var _data = new List.generate(100, (i) => List.filled(100, 0));
int _pointCounter = 0;
bool _scanActive = false;

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class GpsPainter extends CustomPainter {
  var _repaint;

  GpsPainter({Listenable repaint}) : super(repaint: repaint) {
    _repaint = repaint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double scale = 0.5;
    canvas.rotate(-_repaint.value.toDouble() * math.pi / 180);
    canvas.scale(scale);
    int resolutionRect = 100;
    double imageHeight = resolutionRect.toDouble() * 4;
    double offsetHeight = -imageHeight * 1 * scale;
    double colorLevels = 9.0;
    double sizeRect = 4;

    var paint1 = new Paint();
    paint1.color = Color.fromARGB(255, 0, 255, 0);

    Interpolate interR = Interpolate(
      inputRange: [0, colorLevels],
      outputRange: [255, 0],
      extrapolate: Extrapolate.clamp,
    );
    Interpolate interG = Interpolate(
      inputRange: [0, 9],
      outputRange: [0, 255],
      extrapolate: Extrapolate.clamp,
    );

    for(int i = 0; i < _data.length; i++){
      for(int j = 0; j < _data[0].length; j++){
        paint1.color = Color.fromARGB(255, interR.eval(_data[i][j].toDouble()).toInt(), interG.eval(_data[i][j].toDouble()).toInt(), 0);
        canvas.drawRect(Offset(offsetHeight + i.toDouble()*sizeRect, offsetHeight + j.toDouble()*sizeRect) & Size(sizeRect,sizeRect), paint1);
      }
    }

    paint1.color = Color.fromARGB(255, 0, 255, 0);
    if (_scanActive) {
      if (_pointCounter == 1) {
        canvas.drawRect(Offset(-215, -215) & Size(10,10), paint1);
      } else if (_pointCounter == 2) {
        canvas.drawRect(Offset(210, -215) & Size(10,10), paint1);
      } else if (_pointCounter == 3) {
        canvas.drawRect(Offset(210, 210) & Size(10,10), paint1);
      } else if (_pointCounter == 4) {
        canvas.drawRect(Offset(-215, 210) & Size(10,10), paint1);
      }
    }


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

  List<Vector2> measurePoints = new List<Vector2>();
  List<int> strengths = new List<int>();

  UI.Image image;

  @override
  void initState() {
    super.initState();
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


  Future<void> updateGPS() async {
    var tmp = await FlutterCompass.events.first;
    gpsController.text = tmp.toString();
    valueGps.value = tmp.toInt();
  }

  Future<void> updateWifi() async {
    var tmp = await WifiInfoPlugin.wifiDetails;
    wifiController.text = tmp.signalStrength.toString();
  }

  void updateColors() {
    _data = new List.generate(100, (i) => List.filled(100, 0));

    for (int i = 0; i < measurePoints.length; i++) {
      for (int j = 0; j < _data.length; j++) {
        for (int k = 0; k < _data[0].length; k++) {
          _data[j][k] += calcDistance(measurePoints[i].x, measurePoints[i].y, j, k, strengths[i]);
        }
      }
    }

  }

  int calcDistance(double x, double y, int index1, int index2, maxStrength) {
    var maxRange = 30.0*(maxStrength/9.0);
    Interpolate interDistance = Interpolate(
      inputRange: [0, maxRange],
      outputRange: [9, 0],
      extrapolate: Extrapolate.clamp,
    );
    return interDistance.eval(math.sqrt(
        math.pow(x - index1, 2) +
            math.pow(y - index2, 2)))
        .clamp(0, maxStrength)
        .toInt();
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
    _scanActive = true;
    _pointCounter = 1;
    measurePoints = new List<Vector2>();
    strengths = new List<int>();
    updateColors();
  }

  _setScan() async {
    if (_scanActive) {
      if (_pointCounter == 1) {
        moveEast();
        measurePoints.add(new Vector2(20, 20));
        _pointCounter++;
      } else if (_pointCounter == 2) {
        moveSouth();
        measurePoints.add(new Vector2(80, 20));
        _pointCounter++;
      } else if (_pointCounter == 3) {
        measurePoints.add(new Vector2(80, 80));
        moveWest();
        _pointCounter++;
      } else if (_pointCounter == 4) {
        measurePoints.add(new Vector2(20, 80));
        _showDialog("Finished scan", "All Points have been scanned");
        _scanActive = false;
        _pointCounter = 0;
        var tmp = await WifiInfoPlugin.wifiDetails;
        strengths.add(tmp.signalStrength);
        updateColors();
        await addData(measurePoints, strengths);
        return;
      }
      var tmp = await WifiInfoPlugin.wifiDetails;
      strengths.add(tmp.signalStrength);
      updateColors();
    }
  }

  _stopScan() async {
    if (_scanActive == true) {
      _showDialog("Finished scan", "All Points have been scanned");
      _scanActive = false;
      _pointCounter = 0;
      await addData(measurePoints, strengths);
    }
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

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;
