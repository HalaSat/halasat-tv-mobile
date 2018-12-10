import 'package:flutter/material.dart';
import './tv.dart';

class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player Screen"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(
                context, MaterialPageRoute(builder: (context) => TVScreen()));
          },
          child: Text('Go home!'),
        ),
      ),
    );
  }
}
