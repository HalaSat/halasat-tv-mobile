import 'package:flutter/material.dart';
// import './tv.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';

class PlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Player Screen"),
      ),
      body: Text('This is the player screen'),
    );
  }
}

// class PlayerScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => PlayerScreenState();
// }

// class PlayerScreenState extends State<PlayerScreen> {
//   VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(
//       'https://r4---sn-4g5e6nes.googlevideo.com/videoplayback?c=WEB&clen=8230208&itag=18&ipbits=0&ratebypass=yes&txp=5431432&key=cms1&expire=1544533319&id=o-AMGckbxQM3aFiljxazk_hdYh1kUncgFMc4s7RP7ZDY4C&source=youtube&pl=24&requiressl=yes&ip=50.31.8.155&mime=video%2Fmp4&ei=52APXJ7tK8eCir4PufGiuAI&sparams=clen,dur,ei,expire,gir,id,ip,ipbits,ipbypass,itag,lmt,mime,mip,mm,mn,ms,mv,pl,ratebypass,requiressl,source&lmt=1544039733098969&gir=yes&beids=9466588&dur=312.145&fvip=4&signature=6082874EF123533E79420E5A34AA384BA05F3F3B.5D41F7A0F5EC0012C9A08197DBEC327D8558CF79&video_id=xSNlsSfvwac&title=Awesome+loading+screen+using+only+HTML+%26+CSS&rm=sn-vgqrd7z&fexp=9466588,23763603&req_id=7c3d4a917003a3ee&ipbypass=yes&mip=91.106.32.50&redirect_counter=2&cm2rm=sn-x5guiapo3uxax-cbfy7z&cms_redirect=yes&mm=29&mn=sn-4g5e6nes&ms=rdu&mt=1544510778&mv=u',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Player Screen"),
//       ),
//       body: Center(
//         child: new Chewie(
//           _controller,
//           aspectRatio: 3 / 2,
//           autoPlay: true,
//           looping: true,

//           // Try playing around with some of these other options:

//           // showControls: false,
//           // materialProgressColors: new ChewieProgressColors(
//           //   playedColor: Colors.red,
//           //   handleColor: Colors.blue,
//           //   backgroundColor: Colors.grey,
//           //   bufferedColor: Colors.lightGreen,
//           // ),
//           // placeholder: new Container(
//           //   color: Colors.grey,
//           // ),
//           // autoInitialize: true,
//         ),
//       ),
//     );
//   }
// }
