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
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
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
              itemBuilder: /*1*/ (context, i) {
                if (i.isOdd) return Divider(); /*2*/

                final index = i ~/ 2; /*3*/
                if (index >= _suggestions.length) {
                  _suggestions.addAll(generateWordPairs().take(10)); /*4*/
                }
                return _buildRow(_suggestions[index]);
              })
      ),
    );
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      onTap: () {
      },
    );
  }
// #enddocregion _buildRow

// #docregion RWS-build
// #enddocregion RWS-build
// #docregion RWS-var
}