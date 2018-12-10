import 'package:flutter/material.dart';

import '../screens/player_details.dart';

class PlayerInfoCard extends StatelessWidget {
  final Map player;
  PlayerInfoCard(this.player);
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(5.0),
        // margin: EdgeInsets.all(10.0),
        child: InkWell(
          // highlightColor: Colors.blue,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        PlayerDetailsScreen(player)));
          },
          child: Row(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, right: 5.0, left: 5.0),
                  child: CircleAvatar(
                    radius: 35.0,
                    backgroundImage: NetworkImage(
                      player['image'],
                    ),
                  )),
              Container(
                  height: 50,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          player['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          player['origin'],
                        )
                      ])),
            ],
          ),
        ));
  }
}
