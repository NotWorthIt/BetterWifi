import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

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
  var value1 = true;
  var value2 = false;
  var value3 = false;
  var keepScreenAwake = false;

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
        sections: [
          SettingsSection(
            title: 'General',
            tiles: [
              SettingsTile(
                title: 'Language',
                subtitle: 'English',
                leading: Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Delete scan history',
                subtitle: 'Delete',
                leading: Icon(Icons.delete),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile.switchTile(
                title: 'Keep screen awake',
                leading: Icon(Icons.wb_sunny),
                switchValue: keepScreenAwake,
                onToggle: (bool value) {
                  //_onSwitchChanged1(value);
                  _keepScreenAwake(value);
                },
              ),
              SettingsTile.switchTile(
                title: 'Scan wifi',
                leading: Icon(Icons.wifi),
                switchValue: value1,
                onToggle: (bool value) {
                  _onSwitchChanged1(value);
                },
              ),
              SettingsTile.switchTile(
                title: 'Scan mobile connection',
                leading: Icon(Icons.data_usage),
                switchValue: value2,
                onToggle: (bool value) {
                  _onSwitchChanged2(value);
                },
              ),
              SettingsTile.switchTile(
                title: 'Dark mode',
                leading: Icon(Icons.adjust),
                switchValue: value3,
                onToggle: (bool value) {
                  _onSwitchChanged3(value);
                  _showDialog("Information", "Restart required");
                },
              ),
            ],
          ),
        ],
      )),
    );
  }

  void _onSwitchChanged1(bool value) {
    setState(() {
      value1 = value;
    });
  }

  void _onSwitchChanged2(bool value) {
    setState(() {
      value2 = value;
    });
  }

  void _onSwitchChanged3(bool value) async{
    setState(() {
      value3 = value;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value3);

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
