import 'package:flutter/material.dart';
import './home.dart';

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
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Text('Go home!'),
        ),
      ),
    );
  }
}
