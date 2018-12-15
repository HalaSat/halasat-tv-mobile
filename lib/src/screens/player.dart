import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../meta/channels.dart';
import '../widgets/channels_row.dart';

class PlayerScreen extends StatefulWidget {
  final Map data;

  PlayerScreen(this.data);

  @override
  State<StatefulWidget> createState() => PlayerScreenState();
}

class PlayerScreenState extends State<PlayerScreen> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    String app = widget.data['app'];
    String streamName = widget.data['streamname'];
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
    final String title = widget.data['title'];
    final String category = widget.data['cat'];
    final String imageUrl =
        'http://91.106.32.84/images/' + widget.data["image"];

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView(children: <Widget>[
          Chewie(
            _controller,
            aspectRatio: 16 / 9,
            autoPlay: true,
            looping: true,

            // Try playing around with some of these other options:

            // showControls: false,
            // materialProgressColors: new ChewieProgressColors(
            //   playedColor: Colors.red,
            //   handleColor: Colors.blue,
            //   backgroundColor: Colors.grey,
            //   bufferedColor: Colors.lightGreen,
            // ),
            // placeholder: new Container(
            //   color: Colors.grey,
            // ),
            // autoInitialize: true,
          ),
          Container(
              margin: EdgeInsets.only(top: 6.0, left: 6.0),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 25.0,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(title,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Opacity(
                                opacity: .5,
                                child: Row(children: <Widget>[
                                  Icon(
                                    Icons.category,
                                    size: 13,
                                  ),
                                  Text(
                                    category.toUpperCase(),
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
              category: 'Recommended',
              excerpt: 'Explore new channels based on your watch history',
              icon: Icons.explore,
              onCardPressed: (data, context) {
                String app = data['app'];
                String streamName = data['streamname'];
                String url =
                    'http://192.168.37.2:1935/${app}/${streamName}_adaptive.m3u8';
                if (url != _controller.dataSource)
                  setState(() {
                    _controller = VideoPlayerController.network(
                      url,
                    );
                  });
              },
              channels: channels),
          // ChannelsRow(
          //     category: category,
          //     excerpt: 'Top sports channels',
          //     icon: Icons.explore,
          //     onCardPressed: (data, context) {
          //       String app = data['app'];
          //       String streamName = data['streamname'];
          //         _controller.dispose();
          //       setState(() {
          //         _controller = VideoPlayerController.network(
          //           'http://192.168.37.2:1935/$app/${streamName}_adaptive.m3u8', // todo: change to data url
          //         );
          //       });
          //     },
          //     channels: channels)
        ]));
  }
}
