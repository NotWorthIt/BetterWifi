import 'package:flutter/material.dart';
import 'SideDrawer.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPage createState() => _HelpPage();
}

class _HelpPage extends State<HelpPage> {
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Help'),
        ),
        drawer: SideDrawer(),
        body: Center(
            child: Text(
              'Contact us on Gihub: https://github.com/NotWorthIt/MobileComputing',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )));
  }
}
