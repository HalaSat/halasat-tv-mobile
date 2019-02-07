import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import 'package:cloud_firestore/cloud_firestore.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GLOBAL CHAT'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          _buildChatList(context),
          _buildMessageInput(context),
        ],
      ),
    );
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
          child: ListView.builder(
            reverse: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildChatItem(
                  context, snapshot.data.documents[index].data);
            },
          ),
        );
      },
    );
  }

  Widget _buildChatItem(BuildContext context, Map message) {
    return Text(message['content']);
  }

  Widget _buildMessageInput(BuildContext context) {
    return Form(
      key: _messageInputFormKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(onSaved: (value) => _message = value),
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
                  'from': 'Mohammed Salman',
                });
              _messageInputFormKey.currentState.reset();
            },
          ),
        ],
      ),
    );
  }
}
