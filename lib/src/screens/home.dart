import 'package:flutter/material.dart';
import '../meta/channels.dart';
import '../widgets/channels_row.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.all(0.0),
      children: <Widget>[
        ChannelsRow('Sports', channels),
        ChannelsRow('Entertainment', channels),
        ChannelsRow('Movies', channels),
        ChannelsRow('Kids', channels),
        ChannelsRow('Music', channels),
      ],
    ));
  }
}
