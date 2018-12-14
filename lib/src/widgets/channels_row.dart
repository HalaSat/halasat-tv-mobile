import 'package:flutter/material.dart';

import './channel_card.dart';

class ChannelsRow extends StatelessWidget {
  final List<Map<String, String>> channels;
  final String category;
  final IconData icon;
  final String excerpt;
  final Color iconColor;
  final onCardPressed;
  // filter channels by category
  static List<Map<String, String>> filterChannels(
      String cat, List<Map<String, String>> channels) {
    List items = channels
        .where((Map<String, String> item) => item["cat"] == cat)
        .toList();
    return items.isNotEmpty ? items : channels;
  }

  ChannelsRow({
    @required this.category,
    @required this.excerpt,
    @required this.icon,
    @required this.channels,
    @required this.onCardPressed,
    this.iconColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> items = filterChannels(category, channels);
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 15.0),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20.0,
                  ),
                ),
                Text(
                  category.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    // color: iconColor
                  ),
                )
              ])),
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 15.0),
            child: Text(
              excerpt,
              style: TextStyle(
                  fontWeight: FontWeight.w300, color: Colors.grey[600]),
            ),
          ),
          // Divider(color: Colors.blue),
          Container(
            height: 173.0,
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                bool isLastChild = items.length == index + 1;
                return ChannelCard(
                  data: items[index],
                  isLastChild: isLastChild,
                  onPressed: (data, context) => onCardPressed(data, context),
                );
              },
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
