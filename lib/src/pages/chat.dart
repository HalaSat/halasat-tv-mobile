import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../helpers/check_isp.dart';

class ChatPage extends StatefulWidget {
  final FirebaseUser user;

  ChatPage({@required this.user});

  _ChatPageState createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<FormState> _messageInputFormKey = GlobalKey<FormState>();
  final Firestore _firestore = Firestore.instance;

  String _message;
  Size _size;
  // bool _isHalasat;

  @override
  void initState() {
    // checkIsp().then((bool isHalasat) {
    //   setState(() => _isHalasat = isHalasat);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return _buildChat(context);
  }

  Widget _buildChat(BuildContext context) {
    // if (isHalasat == true)
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        _buildChatList(context),
        _buildMessageInput(context),
      ],
    );
    // else if (isHalasat == false)
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('GLOBAL CHAT'),
    //     ),
    //     body: Flex(
    //       direction: Axis.vertical,
    //       children: <Widget>[
    //         _buildChatList(context),
    //         _buildMessageInput(context),
    //       ],
    //     ),
    //   );
    // else
    //   return Center(
    //     child: CupertinoActivityIndicator(),
    //   );
  }

  Widget _buildChatList(BuildContext context) {
    Stream<QuerySnapshot> _stream = _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return StreamBuilder(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Expanded(child: CupertinoActivityIndicator());
        return Flexible(
          child: GestureDetector(
            child: ListView.builder(
              reverse: true,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildChatItem(
                    context, snapshot.data.documents[index].data);
              },
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
        );
      },
    );
  }

  Widget _buildChatItem(BuildContext context, Map message) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
            message['timestamp'].millisecondsSinceEpoch * 1000)
        .toLocal();
    String dateString =
        '${date.day}-${date.month}-${date.year} ${date.hour}:${date.minute}';
    return Container(
      margin: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 10.0, top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(message['from']['photo']),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                message['from']['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.user?.email == message['from']['email']
                      ? Theme.of(context).accentColor
                      : Colors.white,
                ),
              ),
              Container(
                width: (_size.width - 25.0) / 1.2,
                child: Text(message['content']),
              ),
              Text(
                dateString,
                style: TextStyle(color: Colors.white54, fontSize: 11.0),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: Colors.white12,
        child: Form(
          key: _messageInputFormKey,
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10.0)),
                  maxLines: null,
                  maxLengthEnforced: false,
                  textCapitalization: TextCapitalization.sentences,
                  onSaved: (value) => _message = value,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  _messageInputFormKey.currentState.save();
                  if (_message.trim().isNotEmpty)
                    _firestore.collection('messages').add({
                      'content': _message,
                      'timestamp': DateTime.now(),
                      'from': {
                        'name': widget.user.displayName,
                        'photo': widget.user.photoUrl,
                        'email': widget.user.email,
                      },
                    });
                  _messageInputFormKey.currentState.reset();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
