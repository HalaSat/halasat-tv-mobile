import 'package:flutter/material.dart';
import '../meta/channels.dart';
import '../widgets/channels_row.dart';

class TVScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        ChannelsRow(
            category: 'Recent', icon: Icons.history, channels: channels),
        ChannelsRow(
            category: 'Sports', icon: Icons.directions_run, channels: channels),
        ChannelsRow(
            category: 'Entertainment',
            icon: Icons.featured_video,
            channels: channels),
        ChannelsRow(category: 'Movies', icon: Icons.movie, channels: channels),
        ChannelsRow(
            category: 'Kids', icon: Icons.child_care, channels: channels),
        ChannelsRow(
            category: 'Music', icon: Icons.music_note, channels: channels),
      ],
    ));
  }
}
