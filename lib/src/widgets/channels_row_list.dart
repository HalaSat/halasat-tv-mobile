import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/channels_row.dart';
import '../screens/player.dart';

class ChannelsRowList extends StatefulWidget {
  final List<Map<String, String>> _channels;

  ChannelsRowList(this._channels);

  @override
  ChannelsRowListState createState() {
    return ChannelsRowListState();
  }
}

class ChannelsRowListState extends State<ChannelsRowList> {
  List<Map<String, String>> _recentChannels = [];

  @override
  void initState() {
    super.initState();
    _setRecentChannels(widget._channels);
  }

  @override
  Widget build(BuildContext context) {
    var _channels = widget._channels;
    return ListView(
      // padding: EdgeInsets.only(top: 10.0),
      children: <Widget>[
        _recentChannels.isNotEmpty
            ? ChannelsRow(
                category: 'Recent',
                excerpt: 'Your watch history',
                icon: Icons.history,
                onCardPressed: _onCardPressed,
                iconColor: Colors.purple,
                channels: _recentChannels)
            : Text(''),
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

  _setRecentChannels(List<Map<String, String>> channels) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recent =
        new List<String>.from((await prefs.get('recent')) ?? []);
    List<Map<String, String>> recentChannels = recent.reversed
        .toSet() // remove duplicates
        .toList() // convert the set to a list
        .map((itemId) => // map each id to a channel
            channels.where((channel) => channel['id'] == itemId).toList()[0])
        .toList(); // convert iterable to a list

    setState(() {
      _recentChannels = new List<Map<String, String>>.from(recentChannels);
      print(
        '''
            ########
            ********
            --------
                  recentChannels: $_recentChannels
            --------
            ********
            ########
            ''',
      );
    });
  }

  _onCardPressed(Map data, BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PlayerScreen(data)));
  }
}
