import 'dart:convert';
import '../meta/channels.dart';
import '../models/channel.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

List<Channel> _buildChannelsList({@required List<dynamic> jsonData}) {
  return jsonData.map((item) => Channel(channelData: item)).toList();
}

Future<List<Channel>> getRawChannelsData(String url) async {
  List<Channel> channels;
  await http.get(url).then((res) {
    List temp = json.decode((res.body));
    channels = _buildChannelsList(jsonData: temp);
  });
  return channels;
}
