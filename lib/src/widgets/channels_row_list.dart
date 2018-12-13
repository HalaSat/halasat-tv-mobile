import 'package:flutter/material.dart';

import '../widgets/channels_row.dart';

class ChannelsRowList extends StatelessWidget {
  final List<Map<String, String>> _channels;

  ChannelsRowList(this._channels);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        ChannelsRow(
            category: 'Recent',
            excerpt: 'Your watch history',
            icon: Icons.history,
            iconColor: Colors.purple,
            channels: _channels),
        ChannelsRow(
            category: 'Recommended',
            excerpt: 'Recommended channels based on your watch history',
            icon: Icons.explore,
            iconColor: Colors.indigo,
            channels: _channels),
        ChannelsRow(
            category: 'Sports',
            excerpt: 'Top Sport channels',
            icon: Icons.directions_run,
            iconColor: Colors.green,
            channels: _channels),
        ChannelsRow(
            category: 'Entertainment',
            excerpt: 'News, Science, TV shows and many others',
            icon: Icons.featured_video,
            iconColor: Colors.orange,
            channels: _channels),
        ChannelsRow(
            category: 'Movies',
            excerpt: 'Top channels for movie lovers',
            icon: Icons.movie,
            iconColor: Colors.red,
            channels: _channels),
        ChannelsRow(
            category: 'Kids',
            excerpt: 'Channels tailored just for kids',
            icon: Icons.child_care,
            iconColor: Colors.pink,
            channels: _channels),
        ChannelsRow(
            category: 'Music',
            excerpt: 'Enjoy the beats with top music channels',
            icon: Icons.music_note,
            iconColor: Colors.cyan,
            channels: _channels),
      ],
    );
  }
}
