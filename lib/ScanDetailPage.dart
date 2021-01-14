import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:interpolate/interpolate.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';

import 'ScanHistoryPage.dart';
import 'SideDrawer.dart';

var _data = new List.generate(100, (i) => List.filled(100, 0));

class GpsPainter extends CustomPainter {
  var _repaint;

  GpsPainter({Listenable repaint}) : super(repaint: repaint) {
    _repaint = repaint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    /*
    var paint1 = Paint()
      ..color = Color(0xff638965)
      ..style = PaintingStyle.fill;
                                   */
    double scale = 0.5;
    canvas.rotate(-_repaint.value.toDouble() * math.pi / 180);
    canvas.scale(scale);
    int resolutionRect = 100;
    double imageHeight = resolutionRect.toDouble() * 4;
    double offsetHeight = -imageHeight * 1 * scale;
    double colorLevels = 9.0;

    var paint1 = new Paint();
    paint1.color = Color.fromARGB(255, 0, 255, 0);
    //var data = new List.generate(resolutionRect, (i) => List.filled(resolutionRect, 0));

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

    for (int i = 0; i < _data.length; i++) {
      for (int j = 0; j < _data[0].length; j++) {
        paint1.color = Color.fromARGB(255, interR.eval(_data[i][j].toDouble()).toInt(), interG.eval(_data[i][j].toDouble()).toInt(), 0);
        canvas.drawRect(Offset(offsetHeight + i.toDouble() * 4, offsetHeight + j.toDouble() * 4) & Size(4, 4), paint1);
      }
    }

    /* if (_image != null) {
      canvas.drawImage(_image, Offset(offsetHeight, offsetHeight), paint1);
    }*/
    //canvas.drawRect(Offset(0, 0) & Size(50, 100), paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
class ScanDetailPage extends StatefulWidget {
  Data data;
  ScanDetailPage(Data data) {
    this.data = data;
  }
  @override
  _ScanDetailPage createState() => _ScanDetailPage(data);
}

class _ScanDetailPage extends State<ScanDetailPage> {
  Data data;
  _ScanDetailPage(Data data) {
    this.data = data;
    updateColors();
  }

  void updateColors() {
    _data = new List.generate(100, (i) => List.filled(100, 0));
    for (int i = 0; i < data.coordinates.length; i++) {
      for (int j = 0; j < _data.length; j++) {
        for (int k = 0; k < _data[0].length; k++) {
          _data[j][k] += calcDistance(data.coordinates[i].x, data.coordinates[i].y, j, k, data.strengths[i]);
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


  final gpsController = TextEditingController();
  Timer timerGps;
  GpsPainter painterGps;
  final valueGps = ValueNotifier<int>(0);

  final wifiController = TextEditingController();
  Timer timerWifi;

  final instructionsController = TextEditingController();

  Future<void> updateGPS() async {
    var tmp = await FlutterCompass.events.first;
    gpsController.text = tmp.toString();
    valueGps.value = tmp.toInt();
  }

  @override
  void initState() {
    super.initState();
    timerGps = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateGPS());
    painterGps = GpsPainter(repaint: valueGps);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(""),
        ),
        body: Center(
            child: (
                CustomPaint(
          painter: painterGps,
        ))));
  }
}
