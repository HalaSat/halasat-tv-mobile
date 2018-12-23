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
        // padding: EdgeInsets.all(10.0),
        children: <Widget>[
          // header
          Container(
              margin: EdgeInsets.only(bottom: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0)),
                color: Colors.purple,
                gradient: new LinearGradient(
                  colors: [Colors.black54, Colors.blue],
                ),
              ),
              padding: EdgeInsets.all(10.0),
              child: Column(children: [
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
                                fontSize: 20.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.white)))),
                Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Align(
                        child: Text(
                      player['origin'],
                      style: TextStyle(color: Colors.white),
                    )))
              ])),
          // header end
          // Divider(),
          // body
          Align(
            child: Text(
              'About',
              style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            // color: Color.fromARGB(100, 200, 200, 200),
            child: Text(
              player['about'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // body end
        ],
      ),
    );
  }
}
