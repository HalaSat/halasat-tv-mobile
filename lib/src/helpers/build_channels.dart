import 'dart:convert';
import '../meta/channels.dart';
import '../models/channels.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

List<Channel> buildChannelsList({@required List<Map<String, String>> jsonData}) {
  final List<Map<String, String>> channelsRawList = channels;
  final List<Channel> channelsList = List<Channel>();
  channelsRawList.forEach((map) {
    Channel channel = Channel(channelData: map);
    channelsList.add(channel);
  });
  return channelsList;
}

void getRawChannelsData(String url) {
  http.get(url).then((res) {
    List<Map<String, String>> temp = json.decode((res.body));
    print(temp);
    List<Channel> channels = buildChannelsList(jsonData:temp);
    return channels;
    
  });
}
