import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:wifi_tool/SideDrawer.dart';

class ScanHistory extends StatefulWidget {
  @override
  _ScanHistory createState() => _ScanHistory();
}

class _ScanHistory extends State<ScanHistory> {
  final _suggestions = <WordPair>[];
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Scan history'),
      ),
      drawer: SideDrawer(),
      body: Container(
          child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                if (i.isOdd) return Divider();
                final index = i ~/ 2;
                if (index >= _suggestions.length) {
                  _suggestions.addAll(generateWordPairs().take(10));
                }
                return _buildRow(_suggestions[index]);
              })
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      onTap: () {
        _showDialog(pair.asPascalCase, "TODO go to scan");
      },
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