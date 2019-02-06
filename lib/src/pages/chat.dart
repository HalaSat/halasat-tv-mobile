import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;

class ChatPage extends StatefulWidget {
  final FirebaseUser user;

  ChatPage({@required this.user});

  _ChatPageState createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  Widget _messageInput = Row(
    children: <Widget>[
      Expanded(child: TextField()),
      IconButton(
        icon: Icon(
          Icons.send,
        ),
        onPressed: () {},
      )
    ],
  );
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
          _messageInput,
        ],
      ),
    );
  }

  Widget _buildChatList(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return _buildChatItem(context, index);
        },
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, int index) {
    return Text('this is a message');
  }
}
