import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/channels.dart';
import '../models/channel.dart';

class ChannelCard extends StatelessWidget {
  final Channel data;
  final bool isLastChild;
  final Function onPressed;
  final bool hasFocus;
  final Color tvColor = Colors.grey[300];
  final Color phoneColor = Colors.transparent;

  ChannelCard({
    @required this.data,
    @required this.onPressed,
    this.hasFocus = false,
    this.isLastChild = false,
  });

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    Color appliedColor = screenSize < 960.0 ? phoneColor : tvColor;
    return Container(
        decoration:
            BoxDecoration(color: hasFocus ? appliedColor : Colors.transparent),
        margin: EdgeInsets.only(left: 15.0, right: isLastChild ? 15.0 : 0.0),
        child: InkWell(
          // radius: 10.0,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: .2)),
                        child: FadeInImage.assetNetwork(
                          height: 150.0,
                          width: 150.0,
                          fit: BoxFit.cover,
                          image: 'http://91.106.32.84/images/' + data.imageUrl,
                          placeholder: 'assets/placeholder.png',
                        ))),
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: Text(
                      data.title,
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w700),
                    )),
              ])),
          onTap: () async {
            // create a new instance of shared preferences
            SharedPreferences prefs = await SharedPreferences.getInstance();

            // build a list of strings from the dynamic list of recent channel
            List<String> recent = new List<String>.from(
              // get recent channel if they exist, otherwise return an empty list
              await prefs.get('recent') ?? List<String>(),
            );

            // add the the pressed channel to the recent list
            recent.add(data.id.toString());

            // set shared preferences with recent channels
            await prefs.setStringList('recent', recent);
            // call the onPressed callback from channel row
            onPressed(context, data);
          },
        ));
  }
}
