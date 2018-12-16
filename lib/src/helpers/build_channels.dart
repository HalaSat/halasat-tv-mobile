import 'dart:convert';
import '../meta/channels.dart';
import '../models/channel.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

List<Channel> _buildChannelsList({@required List<dynamic> jsonData}) {
  final List<dynamic> channelsRawList = channels;
  final List<Channel> channelsList = List<Channel>();
  channelsRawList.forEach((map) {
    Channel channel = Channel(channelData: map);
    channelsList.add(channel);
  });
  return channelsList;
}

Future<List<Channel>> getRawChannelsData(String url) async {
  List<Channel> channels;
  await http.get(url).then((res) {
    List<dynamic> temp = json.decode((res.body));
    channels = _buildChannelsList(jsonData: temp);
  });
  channels.length;
  return channels;
}
