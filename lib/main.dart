import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_info_plugin/wifi_info_plugin.dart';
import 'package:flutter_compass/flutter_compass.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internet connectivity',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Internet connectivity'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text('Check connectivity'),
            onPressed: _checkInternetConnectivity,
          ),
        ));
  }

  _checkInternetConnectivity() async {
    // var result = await Connectivity().checkConnectivity();
    WifiInfoWrapper wifiObject;
    //var tmp = await FlutterCompass.events.first;
    try {
      wifiObject = await WifiInfoPlugin.wifiDetails;
      var tmp = await FlutterCompass.events.first;

      // String result = wifiObject.signalStrength.toString();

      String result = "Network: "+wifiObject.signalStrength.toString()+ " GPS: " + tmp.toString();

      _showDialog("signal strength", result);
    } on PlatformException {
      _showDialog("Platform not support", "");
    }

    /*
    if (result == ConnectivityResult.none) {
      _showDialog(
          'No internet',
          "You're not connected to a network"
      );
    } else if (result == ConnectivityResult.mobile) {
      _showDialog(
          'Internet access',
          "You're connected over mobile data"
      );
    } else if (result == ConnectivityResult.wifi) {
      _showDialog(
          'Internet access',
          "You're connected over wifi"
      );
    }

     */
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
