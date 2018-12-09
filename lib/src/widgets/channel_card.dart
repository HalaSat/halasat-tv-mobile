import 'package:flutter/material.dart';

import '../screens/player.dart';

class ChannelCard extends StatelessWidget {
  final Map<String, String> data;

  ChannelCard(this.data);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(5.0),
      child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
            FadeInImage(
              height: 150.0,
              width: 150.0,
              fit: BoxFit.cover,
              image:
                  NetworkImage('http://tv.halasat.net/images/' + data["image"]),
              placeholder: AssetImage('assets/placeholder.png'),
            ),
            Text(data["title"])
          ])),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen()));
      },
    );
  }
}
