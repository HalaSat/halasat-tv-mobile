import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:scoped_model/scoped_model.dart';

import './src/helpers/auth.dart';
import './src/models/account.dart';
import './src/pages/tv.dart';
import './src/pages/login.dart';
import './src/helpers/check_isp.dart';

void main() {
  final AccountModel account = AccountModel();

  runApp(ScopedModel<AccountModel>(
    model: account,
    child: App(),
  ));
}

class App extends StatefulWidget {
  @override
  AppState createState() {
    return AppState();
  }
}

class AppState extends State<App> {
  final Auth _auth = Auth();
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
          accentColor: Colors.red,
          buttonColor: Colors.red,
          primaryColor: Colors.black,
          brightness: Brightness.dark,
        ),
        home: _buildHome(context, _isHalasat));
  }

  _buildHome(BuildContext context, bool isHalasat) {
    if (isHalasat == true)
      return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    ScopedModel.of<AccountModel>(context).status =
                        AccountStatus.signing;
                    _auth.signOut().then((void v) {
                      ScopedModel.of<AccountModel>(context).status =
                          AccountStatus.signedOut;
                    });
                  },
                )
              ],
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
          appBar: AppBar(
            title: Text('HalaSat TV'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  ScopedModel.of<AccountModel>(context).status =
                      AccountStatus.signing;
                  _auth.signOut().then((void v) {
                    ScopedModel.of<AccountModel>(context).status =
                        AccountStatus.signedOut;
                  });
                },
              )
            ],
          ),
          body: LoginPage());
    else
      return Center(
        child: CupertinoActivityIndicator(),
      );
  }
}
