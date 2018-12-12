import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

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
      'http://192.168.37.2:1935/$app/$streamName/playlist.m3u8',
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
      appBar: AppBar(
        title: Text(widget.data['title']),
      ),
      body: Chewie(
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
    );
  }
}
