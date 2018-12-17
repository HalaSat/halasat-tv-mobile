import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../packages/chewie/lib/chewie.dart';
import '../widgets/channels_row.dart';
import '../models/channel.dart';

class PlayerScreen extends StatefulWidget {
  final String imagesDirectory = 'http://91.106.32.84/images/';
  final Channel data;
  final List<Channel> channels;
  PlayerScreen(this.data, this.channels);

  @override
  State<StatefulWidget> createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController _controller;
  String _title;
  String _category;
  String _imageUrl;

  @override
  void initState() {
    super.initState();
    String app = widget.data.app;
    String streamName = widget.data.streamName;
    _title = widget.data.title;
    _category = widget.data.category;
    _imageUrl = widget.imagesDirectory + widget.data.imageUrl;
    _controller = VideoPlayerController.network(
      'http://192.168.37.2:1935/$app/${streamName}_adaptive.m3u8',
//      'http://stream.shabakaty.com:6001/sport/ch22/ch22_360.m3u8',
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(physics: BouncingScrollPhysics(), children: <Widget>[
      Chewie(
        _controller,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
      ),
      Container(
          margin: EdgeInsets.only(top: 6.0, left: 6.0),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(_imageUrl),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_title,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Opacity(
                            opacity: .5,
                            child: Row(children: <Widget>[
                              Icon(
                                Icons.category,
                                size: 13,
                              ),
                              Text(
                                _category.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              )
                            ])),
                      ]))
            ],
          )),
      Divider(),
      // todo: fix leak
      ChannelsRow(
          category: _category,
          excerpt: 'Recommended channels',
          icon: Icons.explore,
          onCardPressed: _onCardPressed,
          channels: widget.channels),
    ]));
  }

  _onCardPressed(Channel data, BuildContext context) {
    String title = data.title;
    String category = data.category;
    String app = data.app;
    String streamName = data.streamName;
    String url = 'http://192.168.37.2:1935/$app/${streamName}_adaptive.m3u8';
    if (url != _controller.dataSource)
      setState(() {
        _title = title;
        _category = category;
        _imageUrl = widget.imagesDirectory + data.imageUrl;
        _controller = VideoPlayerController.network(
          url,
        );
      });
  }
}
