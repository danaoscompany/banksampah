import 'package:flutter/material.dart';

void main() => runApp(Map());

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: Center(
            child: Text(
          'This is Map screen.',
          style: TextStyle(fontSize: 21),
          textAlign: TextAlign.center,
        )));
  }
}
