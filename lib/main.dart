import 'package:flutter/material.dart';
import './src/screens/home.dart';
import './src/helpers/build_channels.dart';


void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   getRawChannelsData();
  final String t = "title";
    return MaterialApp(
      title:t,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
