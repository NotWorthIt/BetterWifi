
import 'package:flutter/material.dart';
import 'package:wifi_tool/scanHistory.dart';

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
                _showDialog("Go to Scan page", "TODO");
              }
          ),
          ListTile(
              title: Text("Scan history"),
              onTap: () {
                //_showDialog("Go to Scan history page", "TODO");
                Navigator.push(context, MaterialPageRoute(builder: (context) => ScanHistory()),);
              }
          ),
          ListTile(
              title: Text("Settings"),
              onTap: () {
                _showDialog("Go to Settings page", "TODO");
              }
          ),
          ListTile(
              title: Text("Help"),
              onTap: () {
                _showDialog("Go to Help page", "TODO");
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