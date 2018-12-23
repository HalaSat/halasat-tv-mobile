import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';

import '../widgets/channels_row.dart';
import '../screens/player.dart';
import '../models/channel.dart';
import '../helpers/build_channels.dart';
import '../helpers/constants.dart';

class ChannelsRowList extends StatefulWidget {
  @override
  ChannelsRowListState createState() {
    return ChannelsRowListState();
  }
}

class ChannelsRowListState extends State<ChannelsRowList>
    with AfterLayoutMixin<ChannelsRowList> {
  bool isFirst = true;
  bool recentChannelsSet = false;
  List<Channel> _channels;
  List<Channel> _recentChannels = [];
  List<FocusNode> _nodesList;
  FocusNode inFocus;
  int inFocusIndex;
  int inFocusCardIndex = 0;
  Channel inFocusChannelRef;
  FocusNode recentNode;
  FocusNode sportNode;
  FocusNode entertainmentNode;
  FocusNode moviesNode;
  FocusNode kidsNode;
  FocusNode musicNode;
  ScrollController cont;
  int inFocusRowCardsNumber;
  double rowHeight = 260;
  GlobalKey key; 
  List<ScrollController> scrollControllers = [];

  @override
  void afterFirstLayout(BuildContext context) {
    // print("after initializing");
    // print('recent channels activated:'+_recentChannels.length.toString());
     _setChannels().then((result){
      //  print('future result is :'+ result.toString());
      //  print('future result:' + _nodesList.length.toString());
       if(result){
       _nodesList.insert(0, recentNode);
       }
        // print('future result:' + _nodesList.length.toString());
    if (isFirst) {
      FocusScope.of(context).requestFocus(_nodesList.first);
      inFocusIndex = _nodesList.indexOf(_nodesList.first);
      isFirst = false;
    }
    });
    // inFocus = _recentChannels.length == 0 ? sportNode : recentNode;
    // if (isFirst) {
    //   FocusScope.of(context).requestFocus(inFocus);
    //   inFocusIndex = _nodesList.indexOf(inFocus);
    //   isFirst = false;
    // }
  }

  @override
  void initState() {
    // print('initializing');
   
    cont = ScrollController();
    key = GlobalKey();

    _nodesList = List<FocusNode>();
    recentNode = FocusNode();
    sportNode = FocusNode();
    entertainmentNode = FocusNode();
    moviesNode = FocusNode();
    kidsNode = FocusNode();
    musicNode = FocusNode();

    //_nodesList.add(recentNode);
    _nodesList.add(sportNode);
    _nodesList.add(entertainmentNode);
    _nodesList.add(moviesNode);
    _nodesList.add(kidsNode);
    _nodesList.add(musicNode);

    // Initializing Scroll Controllers
    for (var i = 0; i <= 5; i++) {
      ScrollController temp = ScrollController();
      scrollControllers.add(temp);
    }

///////////////////////////////////////////////////////////////////////////////////////
// debug block
    // print(_nodesList.length);
///////////////////////////////////////////////////////////////////////////////////////
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("building");

    return _channels != null
        ? ListView(
            cacheExtent: _nodesList.length * rowHeight,
            controller: cont,
            padding: EdgeInsets.only(top: 10.0),
            children: <Widget>[
              _recentChannels.isNotEmpty
                  ? RawKeyboardListener(
                      child: ChannelsRow(
                        setCardsNumber: setCardsNumber,
                        category: 'Recent',
                        excerpt: 'Your watch history',
                        icon: Icons.history,
                        onCardPressed: _onCardPressed,
                        iconColor: Colors.purple,
                        channels: _recentChannels,
                        rowHasFocus: inFocusIndex == 0 ? true : false,
                        inFocusCardIndex: inFocusCardIndex,
                        scrollController: scrollControllers[0],
                        cardPhysicalKeyListener: onKeyboardEvent,
                        setFocusedChannel: setInFocusChannel,
                      ),
                      focusNode: _nodesList[0],
                      onKey: onKeyboardEvent,
                    )
                  : Text(''),
              RawKeyboardListener(
                key: key,
                child: ChannelsRow(
                  setCardsNumber: setCardsNumber,
                  category: 'Sports',
                  excerpt: 'Top Sport channels',
                  icon: Icons.directions_run,
                  onCardPressed: _onCardPressed,
                  iconColor: Colors.green,
                  channels: _channels,
                  rowHasFocus: inFocusIndex == _nodesList.indexOf(_nodesList.last) -4 ? true : false,
                  scrollController: _recentChannels.isEmpty ? scrollControllers[0] : scrollControllers[1],
                  inFocusCardIndex: inFocusCardIndex,
                  cardPhysicalKeyListener: onKeyboardEvent,
                  setFocusedChannel: setInFocusChannel,
                ),
                focusNode: _recentChannels.isEmpty? _nodesList[0] : _nodesList[1],
                onKey: onKeyboardEvent,
              ),
              RawKeyboardListener(
                child: ChannelsRow(
                  setCardsNumber: setCardsNumber,
                  category: 'Entertainment',
                  excerpt: 'News, Science, TV shows and many others',
                  icon: Icons.featured_video,
                  onCardPressed: _onCardPressed,
                  iconColor: Colors.orange,
                  channels: _channels,
                  rowHasFocus: inFocusIndex == _nodesList.indexOf(_nodesList.last) -3 ? true : false,
                  inFocusCardIndex: inFocusCardIndex,
                  scrollController: _recentChannels.isEmpty ? scrollControllers[1] : scrollControllers[2],
                  cardPhysicalKeyListener: onKeyboardEvent,
                  setFocusedChannel: setInFocusChannel,
                ),
                focusNode: _recentChannels.isEmpty? _nodesList[1] : _nodesList[2],
                onKey: onKeyboardEvent,
              ),
              RawKeyboardListener(
                child: ChannelsRow(
                  setCardsNumber: setCardsNumber,
                  category: 'Movies',
                  excerpt: 'Top channels for movie lovers',
                  icon: Icons.movie,
                  onCardPressed: _onCardPressed,
                  iconColor: Colors.red,
                  channels: _channels,
                  rowHasFocus: inFocusIndex == _nodesList.indexOf(_nodesList.last) -2 ? true : false,
                  inFocusCardIndex: inFocusCardIndex,
                  scrollController: _recentChannels.isEmpty ? scrollControllers[2] : scrollControllers[3],
                  cardPhysicalKeyListener: onKeyboardEvent,
                  setFocusedChannel: setInFocusChannel,
                ),
                focusNode: _recentChannels.isEmpty? _nodesList[2] : _nodesList[3],
                onKey: onKeyboardEvent,
              ),
              RawKeyboardListener(
                child: ChannelsRow(
                  setCardsNumber: setCardsNumber,
                  category: 'Kids',
                  excerpt: 'Channels tailored just for kids',
                  icon: Icons.child_care,
                  onCardPressed: _onCardPressed,
                  iconColor: Colors.pink,
                  channels: _channels,
                  rowHasFocus: inFocusIndex == _nodesList.indexOf(_nodesList.last) -1 ? true : false,
                  scrollController: _recentChannels.isEmpty ? scrollControllers[3] : scrollControllers[4],
                  inFocusCardIndex: inFocusCardIndex,
                  cardPhysicalKeyListener: onKeyboardEvent,
                  setFocusedChannel: setInFocusChannel,
                ),
                focusNode: _recentChannels.isEmpty? _nodesList[3] : _nodesList[4],
                onKey: onKeyboardEvent,
              ),
              RawKeyboardListener(
                child: ChannelsRow(
                  setCardsNumber: setCardsNumber,
                  category: 'Music',
                  excerpt: 'Enjoy the beats with top music channels',
                  icon: Icons.music_note,
                  onCardPressed: _onCardPressed,
                  iconColor: Colors.cyan,
                  channels: _channels,
                  rowHasFocus: inFocusIndex == _nodesList.indexOf(_nodesList.last) ? true : false,
                  inFocusCardIndex: inFocusCardIndex,
                  scrollController: _recentChannels.isEmpty ? scrollControllers[4] : scrollControllers[5],
                  cardPhysicalKeyListener: onKeyboardEvent,
                  setFocusedChannel: setInFocusChannel,
                ),
                focusNode: _nodesList[_nodesList.indexOf(_nodesList.last)],
                onKey: onKeyboardEvent,
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<bool> _setChannels() async {
    List<Channel> items = await getRawChannelsData(CHANNELS_URL);
    var result = await _setRecentChannels(items);
    setState(() {
      _channels = items;
    });
    return result;
  }

  Future<bool> _setRecentChannels(List<Channel> channels) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recent =
        new List<String>.from((await prefs.get('recent')) ?? []);
    List<Channel> recentChannels = recent.reversed
        .toSet() // remove duplicates
        .toList() // convert the set to a list
        .map((itemId) => // map each id to a channel
            channels
                .where((channel) => channel.id.toString() == itemId)
                .toList()[0])
        .toList(); // convert iterable to a list

    setState(() {
      _recentChannels = new List<Channel>.from(recentChannels);
    });

    return _recentChannels.isNotEmpty ? true: false;

  }

  _onCardPressed(Channel data, BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PlayerScreen(data, _channels)));
  }

  void onKeyboardEvent(RawKeyEvent event) {
    RenderBox box = key.currentContext.findRenderObject();
    rowHeight = box.size.height;
    FocusNode requestingNode = FocusNode();
    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      // print('keydown');
      RawKeyDownEvent ev = event;
      RawKeyEventDataAndroid evAndroid = ev.data;
      if (evAndroid.keyCode == 20) {
        if (_nodesList.last == inFocus) {
          requestingNode = _nodesList.first;  //_recentChannels.isNotEmpty ? _nodesList.first : _nodesList[_nodesList.indexOf(_nodesList.first) + 1];
          cont.animateTo(rowHeight * _nodesList.indexOf(_nodesList.first),
              duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
          inFocus = requestingNode;
        } else {
          requestingNode = _nodesList[_nodesList.indexOf(inFocus) + 1];
          cont.animateTo(rowHeight * _nodesList.indexOf(requestingNode),
              duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
          inFocus = requestingNode;
        }
        FocusScope.of(context).requestFocus(requestingNode);
        setState(() {
          inFocusIndex = _nodesList.indexOf(requestingNode);
          inFocusCardIndex = 0;
          scrollControllers[inFocusIndex].animateTo(0.0,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        });
      } else if (evAndroid.keyCode == 19) {
        if (_nodesList.first == inFocus) {
          requestingNode = _nodesList.last;
          cont.animateTo(rowHeight * _nodesList.indexOf(requestingNode),
              duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
          inFocus = requestingNode;
        } else {
          requestingNode = _nodesList[_nodesList.indexOf(inFocus) - 1];
          cont.animateTo(rowHeight * _nodesList.indexOf(requestingNode),
              duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
          inFocus = requestingNode;
        }

        FocusScope.of(context).requestFocus(requestingNode);
        setState(() {
          inFocusIndex = _nodesList.indexOf(requestingNode);
          inFocusCardIndex = 0;
          scrollControllers[inFocusIndex].animateTo(0.0,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        });
      } else if (evAndroid.keyCode == 22) {
        // print('Right');
        // print('inFocus cards count:' + inFocusRowCardsNumber.toString());
        // print('inFocus card index:' + inFocusCardIndex.toString());
        if (inFocusCardIndex == inFocusRowCardsNumber) {
          // print('last right');
        } else if (inFocusCardIndex < inFocusRowCardsNumber) {
          // print('right pressed');
          inFocusCardIndex = inFocusCardIndex + 1;
          scrollControllers[inFocusIndex].animateTo(150.0 * inFocusCardIndex,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
          setState(() {});
        }
      } else if (evAndroid.keyCode == 21) {
        if (inFocusCardIndex == 0) {
        } else if (inFocusCardIndex > 0) {
          inFocusCardIndex = inFocusCardIndex - 1;
          scrollControllers[inFocusIndex].animateTo(150.0 * inFocusCardIndex,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        }
        setState(() {});
      }else if(evAndroid.keyCode == 23){
       _onCardPressed(inFocusChannelRef, context);
    }
    }
  }

  void setCardsNumber(int value) {
    inFocusRowCardsNumber = value - 1;
  }

  void setInFocusChannel(Channel ch){
    inFocusChannelRef = ch;

  }
}

class TestScaf extends StatefulWidget {
  @override
  TestScafState createState() {
    return new TestScafState();
  }
}

class TestScafState extends State<TestScaf> with AfterLayoutMixin<TestScaf> {
  // @override
  // void afterFirstLayout(BuildContext context){
  //   Navigator.of(context)
  //           .pop();
  // }

  @override
  void afterFirstLayout(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RaisedButton(child: Text("data"), onPressed: _onPressed));
  }

  _onPressed() {
    Navigator.of(context).pop();
  }
}
