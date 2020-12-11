
import 'package:flutter/material.dart';
import 'package:wifi_tool/ScanHistoryPage.dart';

import 'HelpPage.dart';
import 'ScanPage.dart';
import 'SettingsPage.dart';

class SideDrawer extends StatefulWidget {
  @override
  _SideDrawer createState() => _SideDrawer();
}

class _SideDrawer extends State<SideDrawer> {
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          ListTile(
              title: Text("Scan"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScanPage()),);
              }
          ),
          ListTile(
              title: Text("Scan history"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScanHistory()),);
              }
          ),
          ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()),);
              }
          ),
          ListTile(
              title: Text("Help"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HelpPage()),);
              }
          ),
        ],
      ),
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