import 'package:flutter/material.dart';


import '../meta/channels.dart';
import '../widgets/channels_row_list.dart';

class TVScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChannelsRowList());
  }
}
