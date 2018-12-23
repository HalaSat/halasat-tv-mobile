import 'package:flutter/material.dart';

import './src/screens/tv.dart';
import './src/screens/players_list.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HalaSat TV',
      theme: ThemeData(fontFamily: 'Ubuntu'),
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
              TVScreen(),
              PlayersListScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
