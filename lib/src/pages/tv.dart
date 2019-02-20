import 'package:flutter/material.dart';

import '../widgets/channels_row_list.dart';

class TvPage extends StatefulWidget {
  @override
  _TvPageState createState() {
    return _TvPageState();
  }
}

class _TvPageState extends State<TvPage> with AutomaticKeepAliveClientMixin {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChannelsRowList();
  }

  @override
  bool get wantKeepAlive => true;
}
