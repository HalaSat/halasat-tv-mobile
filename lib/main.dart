import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

import './src/pages/tv.dart';
import './src/pages/login.dart';
import './src/helpers/check_isp.dart';

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
  bool _isHalasat;
  @override
  void initState() {
    checkIsp().then((isHalasat) {
      setState(() => _isHalasat = isHalasat);
      print('_isHalasat: ' +
          _isHalasat.toString() +
          ' and isHalasat: ' +
          isHalasat.toString());
    });
    print('outside setState, _isHalasat: ' + _isHalasat.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/',
        routes: {
          LoginPage.tag: (context) => LoginPage(),
        },
        debugShowCheckedModeBanner: false,
        title: 'HalaSat TV',
        theme: ThemeData(
          accentColor: Colors.blue,
          primaryColor: Colors.black,
          brightness: Brightness.dark,
        ),
        home: _buildHome(_isHalasat));
  }

  _buildHome(bool isHalasat) {
    if (isHalasat == true)
      return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
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
                TvPage(),
                LoginPage(),
              ],
            ),
          ));
    else if (_isHalasat == false)
      return Scaffold(
          appBar: AppBar(title: Text('HalaSat TV')), body: LoginPage());
    else
      return Center(
        child: CupertinoActivityIndicator(),
      );
  }
}
