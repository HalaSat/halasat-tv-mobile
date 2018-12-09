import 'package:flutter/material.dart';
import './src/screens/home.dart';
// import './src/helpers/build_channels.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.tv)),
                Tab(icon: Icon(Icons.book)),
              ],
            ),
            title: Text('HalaSat TV'),
          ),
          body: TabBarView(
            children: [
              HomeScreen(),
              Icon(
                Icons.book,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
