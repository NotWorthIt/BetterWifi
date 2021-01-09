

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SideDrawer.dart';

class ScanDetailPage extends StatefulWidget {
  @override
  _ScanDetailPage createState() => _ScanDetailPage();
}

class _ScanDetailPage extends State<ScanDetailPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
        title: Text('Scan detail'),
    ),
    body: Center()
    );
  }
}