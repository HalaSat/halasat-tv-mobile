import 'package:flutter/material.dart';

import '../widgets/channels_row_list.dart';

class TVScreen extends StatefulWidget {
  @override
  _TVScreenState createState() {
    return _TVScreenState();
  }
}

class _TVScreenState extends State<TVScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ChannelsRowList());
  }

  @override
  bool get wantKeepAlive => true;
}
