import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/channels_row.dart';
import '../screens/player.dart';
import '../models/channel.dart';
import '../helpers/build_channels.dart';
import '../helpers/constants.dart';

class ChannelsRowList extends StatefulWidget {
  @override
  ChannelsRowListState createState() {
    return ChannelsRowListState();
  }
}

class ChannelsRowListState extends State<ChannelsRowList> {
  List<Channel> _channels;
  List<Channel> _recentChannels = [];

  @override
  void initState() {
    super.initState();
    _setChannels();
  }

  @override
  Widget build(BuildContext context) {
    return _channels != null
        ? ListView(
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
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  _setChannels() async {
    List<Channel> items = await getRawChannelsData(CHANNELS_URL);
    setState(() {
      _channels = items;
      _setRecentChannels(_channels);
    });
  }

  _setRecentChannels(List<Channel> channels) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recent =
        new List<String>.from((await prefs.get('recent')) ?? []);
    List<Channel> recentChannels = recent.reversed
        .toSet() // remove duplicates
        .toList() // convert the set to a list
        .map((itemId) => // map each id to a channel
            channels
                .where((channel) => channel.id.toString() == itemId)
                .toList()[0])
        .toList(); // convert iterable to a list

    setState(() {
      _recentChannels = new List<Channel>.from(recentChannels);
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

  _onCardPressed(Channel data, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PlayerScreen(data, _channels)));
  }
}
