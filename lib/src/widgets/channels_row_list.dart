import 'package:flutter/material.dart';

import '../screens/player.dart';
import '../widgets/channels_row.dart';

class ChannelsRowList extends StatelessWidget {
  final List<Map<String, String>> _channels;

  _onCardPressed(Map data, BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlayerScreen(data)));
  }

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
            onCardPressed: _onCardPressed,
            iconColor: Colors.purple,
            channels: _channels),
        // ChannelsRow(
        //     category: 'Recommended',
        //     excerpt: 'Recommended channels based on your watch history',
        //     icon: Icons.explore,
        //     onCardPressed: _onCardPressed,
        //     iconColor: Colors.indigo,
        //     channels: _channels),
        ChannelsRow(
            category: 'Sports',
            excerpt: 'Top Sport channels',
            icon: Icons.directions_run,
            onCardPressed: _onCardPressed,
            iconColor: Colors.green,
            channels: _channels),
        ChannelsRow(
            category: 'Entertainment',
            excerpt: 'News, Science, TV shows and many others',
            icon: Icons.featured_video,
            onCardPressed: _onCardPressed,
            iconColor: Colors.orange,
            channels: _channels),
        ChannelsRow(
            category: 'Movies',
            excerpt: 'Top channels for movie lovers',
            icon: Icons.movie,
            onCardPressed: _onCardPressed,
            iconColor: Colors.red,
            channels: _channels),
        ChannelsRow(
            category: 'Kids',
            excerpt: 'Channels tailored just for kids',
            icon: Icons.child_care,
            onCardPressed: _onCardPressed,
            iconColor: Colors.pink,
            channels: _channels),
        ChannelsRow(
            category: 'Music',
            excerpt: 'Enjoy the beats with top music channels',
            icon: Icons.music_note,
            onCardPressed: _onCardPressed,
            iconColor: Colors.cyan,
            channels: _channels),
      ],
    );
  }
}
