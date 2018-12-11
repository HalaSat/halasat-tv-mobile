import 'package:flutter/material.dart';
import './tv.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PlayerScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => PlayerScreenState();
    

}

class PlayerScreenState extends State<PlayerScreen>{
  VideoPlayerController _controller;

  @override
  void initState() {
      super.initState();
      _controller = VideoPlayerController.network(
      'http://dl25.telechargerunevideo.com/dl/2.php?token=9879c3a4e4d3e042daa510a8a5f13f814f62bb14&vk=hbyvseSdoSoMaCBUbVvjAdZ91rxCSgMMADTv288-Uew&fn=Ed+Sheeran+-+I+See+Fire',
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
        title: Text("Player Screen"),
      ),
      body: Center(
        child: new Chewie(
                  _controller,
                  aspectRatio: 3 / 2,
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

      ),
    );
  }
}
