import 'package:flutter/foundation.dart';



class Channel {
// constructor
  Channel({@required Map<String, String> channelData}) {
    app = channelData['app'];
    id = int.parse(channelData['id']);
    title = channelData['title'];
    imageUrl = channelData['image'];
    category = channelData['cat'];
    color = channelData['color'];
    streamName = channelData['streamname'];
    epg = int.parse(channelData['epg']);
    order = int.parse(channelData['vorder']);
    enable = int.parse(channelData['enable']);
    type = int.parse(channelData['type']);
  }
// properties
  int id;
  String title;
  String imageUrl;
  String streamName;
  String category;
  String color;
  String app;
  int epg;
  int type;
  int order;
  int enable;
}
