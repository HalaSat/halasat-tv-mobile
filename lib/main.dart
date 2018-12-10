import 'package:flutter/material.dart';

import './src/screens/home.dart';
import './src/screens/players_info.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final FocusNode node = FocusNode();
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
              PlayersInfoScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
