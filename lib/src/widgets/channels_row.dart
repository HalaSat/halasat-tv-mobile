import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

import './channel_card.dart';
import '../models/channel.dart';

class ChannelsRow extends StatefulWidget {
  final List<Channel> channels;
  final String category;
  final IconData icon;
  final String excerpt;
  final Color iconColor;
  final Function onCardPressed;
  final bool rowHasFocus;
  final int inFocusCardIndex;
  final Function setFocusedChannel;
  final Function cardPhysicalKeyListener;
  final ScrollController scrollController;
  final int numberOfCards;
  final Function setCardsNumber;

  ChannelsRow({
    @required this.category,
    @required this.excerpt,
    @required this.icon,
    @required this.channels,
    @required this.onCardPressed,
    @required this.cardPhysicalKeyListener,
    @required this.scrollController,
    @required this.setCardsNumber,
    @required this.setFocusedChannel,
    this.numberOfCards,
    this.inFocusCardIndex,
    this.rowHasFocus,
    this.iconColor = Colors.blue,
  });

  @override
  State<StatefulWidget> createState() {
    return ChannelsRowState();
  }
}

class ChannelsRowState extends State<ChannelsRow>
    with AfterLayoutMixin<ChannelsRow> {
  final List<FocusNode> _rowNodesList = [];

  final List<Channel> items = [];

  final ScrollController rowController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    filterChannels(widget.category, widget.channels, items);
    _generateNodesList();

    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    print(widget.rowHasFocus);
    if (widget.rowHasFocus) {
      FocusScope.of(context)
          .requestFocus(_rowNodesList[widget.inFocusCardIndex]);
      // if(inFocusCardIndex != null){
      // rowController.animateTo(cardWidth, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rowHasFocus) {
      widget.setCardsNumber(items.length);
      widget.setFocusedChannel(items[widget.inFocusCardIndex]);
    }
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(left: 15.0, bottom: 5.0),
              child: Row(children: [
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 18.0,
                  ),
                ),
                Text(
                  widget.excerpt,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    // color: iconColor
                  ),
                )
              ])),
          // Divider(color: Colors.blue),
          Container(
            height: 173.0,
            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: ListView.builder(
              cacheExtent: 150.0 * items.length,
              scrollDirection: Axis.horizontal,
              controller: widget.scrollController,
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                bool isLastChild = items.length == index + 1;
                return RawKeyboardListener(
                  child: ChannelCard(
                    hasFocus:
                        index == widget.inFocusCardIndex && widget.rowHasFocus
                            ? true
                            : false,
                    data: items[index],
                    isLastChild: isLastChild,
                    onPressed: (BuildContext context, Channel data) =>
                        widget.onCardPressed(context, data),
                  ),
                  focusNode: _rowNodesList[index],
                  onKey: widget.cardPhysicalKeyListener,
                );
              },
            ),
          ),
          // Divider(),
        ],
      ),
    );
  }

  void _generateNodesList() {
    int numberOfNodes = items.length;
    for (var i = 0; i < numberOfNodes; i++) {
      FocusNode tempNode = FocusNode();
      _rowNodesList.add(tempNode);
    }
  }

  /// Filter channels by category
  void filterChannels(
      String cat, List<Channel> channels, List<Channel> filteredItems) {
    List<Channel> items =
        channels.where((Channel item) => item.category == cat).toList();
    items = items.isNotEmpty ? items : channels;
    filteredItems.addAll(items);
  }
}
