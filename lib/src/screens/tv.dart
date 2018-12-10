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
            category: 'Recent',
            excerpt: 'Your watch history',
            icon: Icons.history,
            channels: channels),
        ChannelsRow(
            category: 'Recommended',
            excerpt: 'Recommended channels based on your watch history',
            icon: Icons.explore,
            channels: channels),
        ChannelsRow(
            category: 'Sports',
            excerpt: 'Top Sport channels',
            icon: Icons.directions_run,
            channels: channels),
        ChannelsRow(
            category: 'Entertainment',
            excerpt: 'News, Science, TV shows and many others',
            icon: Icons.featured_video,
            channels: channels),
        ChannelsRow(
            category: 'Movies',
            excerpt: 'Top channels for movie lovers',
            icon: Icons.movie,
            channels: channels),
        ChannelsRow(
            category: 'Kids',
            excerpt: 'Channels tailored just for kids',
            icon: Icons.child_care,
            channels: channels),
        ChannelsRow(
            category: 'Music',
            excerpt: 'Enjoy the beats with top music channels',
            icon: Icons.music_note,
            channels: channels),
      ],
    ));
  }
}
