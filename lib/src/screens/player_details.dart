import 'package:flutter/material.dart';

class PlayerDetailsScreen extends StatelessWidget {
  final Map player;
  PlayerDetailsScreen(this.player);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(player['name']),
      ),
      body: ListView(
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          Align(
              child: CircleAvatar(
            radius: 50.0,
            backgroundImage: NetworkImage(player['image']),
          )),
          Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Align(
                  child: Text(player['name'],
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w300)))),
          Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Align(child: Text(player['origin']))),
          Divider(),
          Align(
            child: Text(
              'About',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w300),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            // color: Color.fromARGB(100, 200, 200, 200),
            child: Text(
              player['about'],
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
