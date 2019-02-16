import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

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

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return _buildChat(context);
  }

  Widget _buildChat(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        _buildChatList(context),
        _buildMessageInput(context),
      ],
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

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: message['content']))
            .then((void v) {
          Scaffold.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 1),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Message copied to clipboard   ',
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.content_copy,
                  size: 15.0,
                  color: Colors.white54,
                ),
              ],
            ),
          ));
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 5.0, left: 5.0, bottom: 10.0, top: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: CachedNetworkImage(
                    imageUrl: message['from']['photo'],
                    placeholder: Container(
                        width: 50.0,
                        height: 50.0,
                        child: const CupertinoActivityIndicator()),
                    errorWidget: Container(child: const Icon(Icons.error)),
                    fit: BoxFit.cover,
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
                onTap: () {
                  _initPrivateChat(sender: widget.user, message: message);
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
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
                    message['from']['verified'] == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.blue,
                              size: 15.0,
                            ),
                          )
                        : Container()
                  ],
                ),
                Container(
                  width: (_size.width - 25.0) / 1.2,
                  child: Text(
                    message['content'],
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Text(
                  dateString,
                  style: TextStyle(color: Colors.white54, fontSize: 11.0),
                )
              ],
            ),
          ],
        ),
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
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10.0),
                  ),
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
                      'timestamp': DateTime.now().toLocal(),
                      'from': {
                        'name': widget.user.displayName,
                        'photo': widget.user.photoUrl,
                        'email': widget.user.email,
                        'verified': widget.user.email == 'ms@halasat.com'
                            ? true
                            : false,
                      },
                      'user': _firestore
                          .collection('users')
                          .document(widget.user.uid),
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

  Future<void> _initPrivateChat({FirebaseUser sender, Map message}) async {
    DocumentReference reciever = message['user'];
    if (reciever == null) {
      print('reciever is null');
    } else
      reciever.get().then((user) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
              body:
                  Center(child: Text(sender.displayName + '-' + user['name'])));
        }));
      }).catchError((err) => print('ther is errorrrr $err'));
  }
}
