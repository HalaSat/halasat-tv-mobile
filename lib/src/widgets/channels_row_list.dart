import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';
import 'package:screen/screen.dart';

import '../models/channels.dart';
import '../widgets/channels_row.dart';
import '../pages/player.dart';
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
  bool _channelsLoaded;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _setChannels(context).then((result) {
      if (result) {
        _nodesList.insert(0, recentNode);
      }
      if (isFirst) {
        FocusScope.of(context).requestFocus(_nodesList.first);
        inFocusIndex = _nodesList.indexOf(_nodesList.first);
        isFirst = false;
      }
    });
  }

  @override
  void initState() {
    cont = ScrollController();
    key = GlobalKey();

    _nodesList = List<FocusNode>();
    recentNode = FocusNode();
    sportNode = FocusNode();
    entertainmentNode = FocusNode();
    moviesNode = FocusNode();
    kidsNode = FocusNode();
    musicNode = FocusNode();

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
    Screen.isKeptOn.then((keptOn) {
      if (keptOn) {
        print("Screen On:" + keptOn.toString());
        Screen.keepOn(false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await _setChannels(context);
        },
        child: _buildChannels(context));
  }

  Widget _buildChannels(BuildContext context) {
    if (_channelsLoaded == true)
      return ScopedModelDescendant<ChannelsModel>(
          builder: (BuildContext context, Widget _, ChannelsModel c) {
        return ListView(
          cacheExtent: _nodesList.length * rowHeight,
          controller: cont,
          padding: EdgeInsets.only(top: 10.0),
          children: <Widget>[
            c.recent.isNotEmpty
                ? RawKeyboardListener(
                    child: ChannelsRow(
                      setCardsNumber: setCardsNumber,
                      category: 'Recent',
                      excerpt: 'Recent Channels',
                      icon: Icons.history,
                      onCardPressed: _onCardPressed,
                      iconColor: Colors.purple,
                      channels: c.recent,
                      rowHasFocus: inFocusIndex == 0 ? true : false,
                      inFocusCardIndex: inFocusCardIndex,
                      scrollController: scrollControllers[0],
                      cardPhysicalKeyListener: onKeyboardEvent,
                      setFocusedChannel: setInFocusChannel,
                    ),
                    focusNode: _nodesList[0],
                    onKey: onKeyboardEvent,
                  )
                : SizedBox(),
            RawKeyboardListener(
              key: key,
              child: ChannelsRow(
                setCardsNumber: setCardsNumber,
                category: 'Sports',
                excerpt: 'Top Sports Channels',
                icon: Icons.directions_run,
                onCardPressed: _onCardPressed,
                iconColor: Colors.green,
                channels: _channels,
                rowHasFocus:
                    inFocusIndex == _nodesList.indexOf(_nodesList.last) - 4
                        ? true
                        : false,
                scrollController: c.recent.isEmpty
                    ? scrollControllers[0]
                    : scrollControllers[1],
                inFocusCardIndex: inFocusCardIndex,
                cardPhysicalKeyListener: onKeyboardEvent,
                setFocusedChannel: setInFocusChannel,
              ),
              focusNode: c.recent.isEmpty ? _nodesList[0] : _nodesList[1],
              onKey: onKeyboardEvent,
            ),
            RawKeyboardListener(
              child: ChannelsRow(
                setCardsNumber: setCardsNumber,
                category: 'Entertainment',
                excerpt: 'Entertainment and News',
                icon: Icons.featured_video,
                onCardPressed: _onCardPressed,
                iconColor: Colors.orange,
                channels: _channels,
                rowHasFocus:
                    inFocusIndex == _nodesList.indexOf(_nodesList.last) - 3
                        ? true
                        : false,
                inFocusCardIndex: inFocusCardIndex,
                scrollController: c.recent.isEmpty
                    ? scrollControllers[1]
                    : scrollControllers[2],
                cardPhysicalKeyListener: onKeyboardEvent,
                setFocusedChannel: setInFocusChannel,
              ),
              focusNode: c.recent.isEmpty ? _nodesList[1] : _nodesList[2],
              onKey: onKeyboardEvent,
            ),
            RawKeyboardListener(
              child: ChannelsRow(
                setCardsNumber: setCardsNumber,
                category: 'Movies',
                excerpt: 'Movies and TV Shows',
                icon: Icons.movie,
                onCardPressed: _onCardPressed,
                iconColor: Colors.red,
                channels: _channels,
                rowHasFocus:
                    inFocusIndex == _nodesList.indexOf(_nodesList.last) - 2
                        ? true
                        : false,
                inFocusCardIndex: inFocusCardIndex,
                scrollController: c.recent.isEmpty
                    ? scrollControllers[2]
                    : scrollControllers[3],
                cardPhysicalKeyListener: onKeyboardEvent,
                setFocusedChannel: setInFocusChannel,
              ),
              focusNode: c.recent.isEmpty ? _nodesList[2] : _nodesList[3],
              onKey: onKeyboardEvent,
            ),
            RawKeyboardListener(
              child: ChannelsRow(
                setCardsNumber: setCardsNumber,
                category: 'Kids',
                excerpt: 'Channels Tailored for Kids',
                icon: Icons.child_care,
                onCardPressed: _onCardPressed,
                iconColor: Colors.pink,
                channels: _channels,
                rowHasFocus:
                    inFocusIndex == _nodesList.indexOf(_nodesList.last) - 1
                        ? true
                        : false,
                scrollController: c.recent.isEmpty
                    ? scrollControllers[3]
                    : scrollControllers[4],
                inFocusCardIndex: inFocusCardIndex,
                cardPhysicalKeyListener: onKeyboardEvent,
                setFocusedChannel: setInFocusChannel,
              ),
              focusNode: c.recent.isEmpty ? _nodesList[3] : _nodesList[4],
              onKey: onKeyboardEvent,
            ),
            RawKeyboardListener(
              child: ChannelsRow(
                setCardsNumber: setCardsNumber,
                category: 'Music',
                excerpt: 'Top Music Channels',
                icon: Icons.music_note,
                onCardPressed: _onCardPressed,
                iconColor: Colors.cyan,
                channels: _channels,
                rowHasFocus: inFocusIndex == _nodesList.indexOf(_nodesList.last)
                    ? true
                    : false,
                inFocusCardIndex: inFocusCardIndex,
                scrollController: c.recent.isEmpty
                    ? scrollControllers[4]
                    : scrollControllers[5],
                cardPhysicalKeyListener: onKeyboardEvent,
                setFocusedChannel: setInFocusChannel,
              ),
              focusNode: _nodesList[_nodesList.indexOf(_nodesList.last)],
              onKey: onKeyboardEvent,
            ),
          ],
        );
      });
    else if (_channelsLoaded == false)
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.rotate_left),
              onPressed: () => _setChannels(context),
            ),
            Text('Connection error, please try again.')
          ],
        ),
      );
    else
      return Center(
        child: CupertinoActivityIndicator(),
      );
  }

  Future<bool> _setChannels(BuildContext context) async {
    List<Channel> items;
    setState(() {
      _channelsLoaded = null;
    });
    bool result;
    try {
      items = await getRawChannelsData(CHANNELS_URL);
      result = await _setRecentChannels(context, items);
      setState(() {
        _channels = items;
        _channelsLoaded = true;
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Connected to HalaSat TV',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      setState(() {
        _channelsLoaded = false;
      });
      print(e);
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('You are offline, or not a subsciber of HalaSat',
            textAlign: TextAlign.center),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      ));
    }

    return result;
  }

  Future<bool> _setRecentChannels(
      BuildContext context, List<Channel> channels) async {
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

    ScopedModel.of<ChannelsModel>(context).recent =
        List<Channel>.from(recentChannels);

    return ScopedModel.of<ChannelsModel>(context).recent.isNotEmpty
        ? true
        : false;
  }

  _onCardPressed(BuildContext context, Channel data) {
    Navigator.pushReplacementNamed(context, '/');
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PlayerPage(data, _channels)));
  }

  void onKeyboardEvent(RawKeyEvent event) {
    RenderBox box = key.currentContext.findRenderObject();
    rowHeight = box.size.height;
    FocusNode requestingNode = FocusNode();
    if (event is RawKeyDownEvent && event.data is RawKeyEventDataAndroid) {
      RawKeyDownEvent ev = event;
      RawKeyEventDataAndroid evAndroid = ev.data;
      if (evAndroid.keyCode == 20) {
        if (_nodesList.last == inFocus) {
          requestingNode = _nodesList
              .first; //_recentChannels.isNotEmpty ? _nodesList.first : _nodesList[_nodesList.indexOf(_nodesList.first) + 1];
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
        if (inFocusCardIndex == inFocusRowCardsNumber) {
        } else if (inFocusCardIndex < inFocusRowCardsNumber) {
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
      } else if (evAndroid.keyCode == 23) {
        _onCardPressed(context, inFocusChannelRef);
      }
    }
  }

  void setCardsNumber(int value) {
    inFocusRowCardsNumber = value - 1;
  }

  void setInFocusChannel(Channel ch) {
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
