import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

import 'LanguagesScreen.dart';
import 'SideDrawer.dart';

import 'package:wakelock/wakelock.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  // #enddocregion RWS-var
  var scanWifi = true;
  var scanMobile = true;
  var darkMode = true;
  var keepScreenAwake = true;

  SharedPreferences sharedPrefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() => sharedPrefs = prefs);
      if (!prefs.containsKey("scanWifi")) {
        sharedPrefs.setBool("scanWifi", false);
      }
      scanWifi = sharedPrefs.getBool("scanWifi");

      if (!prefs.containsKey("scanMobile")) {
        sharedPrefs.setBool("scanMobile", false);
      }
      scanMobile = sharedPrefs.getBool("scanMobile");

      if (!prefs.containsKey("keepScreenAwake")) {
        sharedPrefs.setBool("keepScreenAwake", false);
      }
      keepScreenAwake = sharedPrefs.getBool("keepScreenAwake");
    });
  }

  // #docregion _buildSuggestions
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      drawer: SideDrawer(),
      body: Center(
          child: SettingsList(
            backgroundColor: Colors.grey[850],
        sections: [
          SettingsSection(
            title: 'General',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguagesScreen()),
                  );
                },
              ),
              SettingsTile(
                title: 'Delete scan history',
                subtitle: 'Delete',
                leading: Icon(Icons.delete),
                onPressed: (BuildContext context) {
                  _showDialog("Warning", "Are you sure that you want to delete your entire scan history?");
                },
              ),
              SettingsTile.switchTile(
                title: 'Keep screen awake',
                leading: Icon(Icons.wb_sunny),
                switchValue: keepScreenAwake,
                onToggle: (bool value) {
                  _keepScreenAwake(value);
                  sharedPrefs.setBool("keepScreenAwake", value);
                },
              ),
              SettingsTile.switchTile(
                title: 'Scan wifi',
                leading: Icon(Icons.wifi),
                switchValue: scanWifi,
                onToggle: (bool value) {
                  _scanWifi(value);
                  sharedPrefs.setBool("scanWifi", value);
                },
              ),
              SettingsTile.switchTile(
                title: 'Scan mobile connection',
                leading: Icon(Icons.data_usage),
                switchValue: scanMobile,
                onToggle: (bool value) {
                  _scanMobile(value);
                  sharedPrefs.setBool("scanMobile", value);
                },
              ),
            ],
          ),
        ],
      )),
    );
  }

  void _scanWifi(bool value) {
    setState(() {
      scanWifi = value;
    });
  }

  void _scanMobile(bool value) {
    setState(() {
      scanMobile = value;
    });
  }

  var logger = Logger();

  void _keepScreenAwake(bool value) async {
    setState(() {
      keepScreenAwake = value;
    });

    if (keepScreenAwake) {
      Wakelock.enable();
      logger.d("Screen wakelock is ON");
    } else {
      Wakelock.disable();
      logger.d("Screen wakelock is OFF");
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
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  sharedPrefs.clear();
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
