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
              'If you need help contact us at: k1608809@students.jku.at',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            )));
  }
}
