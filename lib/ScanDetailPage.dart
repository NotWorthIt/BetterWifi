

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SideDrawer.dart';

class ScanDetailPage extends StatefulWidget {
  int scanID;
  ScanDetailPage(int scanID){
    this.scanID = scanID;
  }
  @override
  _ScanDetailPage createState() => _ScanDetailPage(scanID);
}

class _ScanDetailPage extends State<ScanDetailPage> {
  int scanID;
  _ScanDetailPage(int scanID){
    this.scanID = scanID;
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
        title: Text(""+ scanID.toString()),
    ),
    body: Center()
    );
  }
}