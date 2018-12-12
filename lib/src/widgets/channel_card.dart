import 'package:flutter/material.dart';

import '../screens/player.dart';

class ChannelCard extends StatelessWidget {
  final Map<String, String> data;
  final bool isLastChild;
  ChannelCard({@required this.data, this.isLastChild = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 15.0, right: isLastChild ? 15.0 : 0.0),
        child: FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                FadeInImage.assetNetwork(
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.cover,
                  image: 'http://91.106.32.84/images/' + data["image"],
                  placeholder: 'assets/placeholder.png',
                ),
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      data["title"],
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w300),
                    )),
              ])),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => PlayerScreen(data)));
          },
        ));
  }
}
