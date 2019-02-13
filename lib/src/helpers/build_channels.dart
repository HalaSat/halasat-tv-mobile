import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../meta/channels.dart';
import '../models/channel.dart';

Future<List<Channel>> getRawChannelsData(String url) async {
  // List<Channel> channels;
  await http.get(url).then((res) {
    List temp = json.decode((res.body));
    channels = _buildChannelsList(jsonData: temp);
  });
  return channels;
}

List<Channel> _buildChannelsList({@required List jsonData}) {
  return jsonData.map((item) => Channel(channelData: Map.from(item))).toList();
}

List<Channel> getLocalChannels() => channels;
