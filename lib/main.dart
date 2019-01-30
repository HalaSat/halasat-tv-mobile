import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './src/screens/tv.dart';
import './src/screens/players_list.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  SharedPreferences _prefs;
  bool _useDarkTheme = true;

  AppState() {
    _getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HalaSat TV',
      theme: _useDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              // Center(child: Text(_useDarkTheme ? 'Dark' : 'Light')),
              Switch(
                value: _useDarkTheme,
                onChanged: (value) {
                  _setTheme(value);
                },
              )
            ],
            leading: Icon(Icons.tv),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.live_tv)),
                Tab(icon: Icon(Icons.message)),
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

  /// Get the used theme from local storage (shared preferences).
  /// If not set then the light theme will be set as default.
  Future<void> _getTheme() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _useDarkTheme = _prefs.getBool('use-dark-theme') ?? false;
    });
  }

  /// Update the theme boolean on local storage.
  /// the [value] is used to set the [_useDarkTheme] with the new theme.
  Future<void> _setTheme(bool value) async {
    setState(() {
      _useDarkTheme = value;
    });
    await _prefs.setBool('use-dark-theme', _useDarkTheme);
  }
}