import 'dart:convert';
import '../meta/channels.dart';
import '../models/channels.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;


List<Channel> buildChannelsList({@required Object jsonData}) {
  final List<Map<String, String>> channelsRawList = channels;
  final List<Channel> channelsList = List<Channel>();
  channelsRawList.forEach((map) {
    Channel channel = Channel(channelData: map);
    channelsList.add(channel);
  });
  return channelsList;
}


void getRawChannelsData() {
  http.get("http://91.106.32.84/api.php").then((res){print(json.decode((res.body).toString()));});
}

