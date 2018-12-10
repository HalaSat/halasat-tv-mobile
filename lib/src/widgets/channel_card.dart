import 'package:flutter/material.dart';

import '../screens/player.dart';

class ChannelCard extends StatelessWidget {
  final Map<String, String> data;

  ChannelCard(this.data);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      // padding: EdgeInsets.all(5.0),
      child: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            FadeInImage.assetNetwork(
              height: 150.0,
              width: 150.0,
              fit: BoxFit.cover,
              image: 'http://tv.halasat.net/images/' + data["image"],
              placeholder: 'assets/placeholder.png',
            ),
            Container(
                margin: EdgeInsets.only(top: 5.0),
                child: Text(
                  data["title"],
                  style: TextStyle(fontWeight: FontWeight.w300),
                )),
          ])),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PlayerScreen()));
      },
    );
  }
}
