import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lovealapp/models/user.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'profile.dart';

class Message extends StatefulWidget {
  final String chatRoomID;
  final String matchID;
  final String nickname;
  final String imgUrl;
  Message(
      {Key key,
      @required this.chatRoomID,
      this.matchID,
      this.nickname,
      this.imgUrl})
      : super(key: key);
  @override
  _MessageState createState() =>
      _MessageState(chatRoomID, matchID, nickname, imgUrl);
}

class _MessageState extends State<Message> {

  //for blur
  double sigmaX;
  double sigmaY;

  @override
  void initState() {
    super.initState();
    getChatted();

    //get matchID and chatID from db
    Firestore.instance.collection('messages').document(chatRoomID).get().then((doc) {
      setState(() {
        sigmaX = doc['blur'].toDouble();
        sigmaY = doc['blur'].toDouble();
      });
    });
  }

  final String chatRoomID;
  final String matchID;
  final String nickname;
  final String imgUrl;
  _MessageState(this.chatRoomID, this.matchID, this.nickname, this.imgUrl);
  // user context from provider
  var user;
  var toID;
  final dbRef = Firestore.instance;
  bool activeChat;

  // check if chatroom is active
  void getChatted() {
    dbRef.collection('messages').document(chatRoomID).get().then((snapshot) => {
          if (snapshot['active'] != null)
            {activeChat = snapshot['active']}
          else
            {activateChat(false), activeChat = false}
        });
  }

  // activate chatroom (a chatroom that has at least one message)
  void activateChat(bool) {
    try {
      dbRef
          .collection('messages')
          .document(chatRoomID)
          .updateData({'active': bool});
    } catch (err) {
      print(err.toString());
    }
  }

  void toggleUnread(DocumentSnapshot document) {
    dbRef
        .collection('messages')
        .document(chatRoomID)
        .collection('chatroom')
        .document(document.documentID)
        .updateData({'unread': false});
  }

  //for reading the contents of the input field and for clearing the field after the text message is sent
  final _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  void _onSendMessage(String text) {
    // toggle chatted if first message
    if (!activeChat) {
      activateChat(true);
    }
    if (text.trim() != "") {
      _textController.clear();
      var documentReference = dbRef
          .collection('messages')
          .document(chatRoomID)
          .collection('chatroom')
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'fromID': user.uid,
            'toID': matchID,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'text': text,
            'unread': true,
          },
        );
      });
    } else {
      // Show error message to user
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  // BODY
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return Scaffold(
        backgroundColor: Hexcolor("#F4AA33"),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
          child: AppBar(
            backgroundColor: Hexcolor("#F4AA33"),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(MdiIcons.arrowLeft)),
            flexibleSpace: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(
                            userID: matchID,
                            nickname: nickname,
                            imgUrl: imgUrl,
                            chatRoomID: chatRoomID)));
              },
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Stack(

                        children: <Widget>[
                          CircleAvatar(
                            radius: 29,
                            backgroundImage: NetworkImage(imgUrl),
                          ),
                          Container(
                              width: 58,
                              height: 58,
                              child: ClipOval(
                                child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: sigmaX  ?? 50, sigmaY: sigmaY  ?? 50),
                                    child: Container(
                                        color:
                                        Colors.black.withOpacity(0))),
                              )),
                        ],
                      ),

                      SizedBox(width: 10.0),
                      Text(
                        nickname,
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            elevation: 0.0,
            centerTitle: true,
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    //LIST OF MESSAGES
                    children: <Widget>[
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Hexcolor('#f1f4f5'),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0),
                              ),
                            ),
                            // builds a list of messages from database
                            // updated in realtime with stream
                            child: StreamBuilder(
                                stream: dbRef
                                    .collection('messages')
                                    .document(chatRoomID)
                                    .collection('chatroom')
                                    .orderBy('timestamp', descending: true)
                                    .limit(20)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                      child: Text('No messages...'),
                                    );
                                  } else {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0),
                                      ),
                                      child: ListView.builder(
                                        padding: EdgeInsets.all(8.0),
                                        reverse: true,
                                        // builds widget for each message in the database
                                        itemBuilder: (context, index) =>
                                            buildMessage(
                                                snapshot.data.documents[index],
                                                context),
                                        itemCount:
                                            snapshot.data.documents.length,
                                      ),
                                    );
                                  }
                                })),
                      ),
                      //INPUT MESSAGE FIELD
                      Container(
                        decoration:
                            BoxDecoration(color: Theme.of(context).cardColor),
                        child: _buildTextInput(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // MESSAGE INPUT AND SEND
  Widget _buildTextInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      color: Colors.white,
      height: 80.0,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Hexcolor('#f1f4f5'),
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: TextField(
                controller: _textController,
                onSubmitted: _onSendMessage,
                focusNode: _focusNode,
                decoration: InputDecoration(
                    hintText: "Send a message...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15.0)),
              ),
            ),
          ),
          SizedBox(width: 12),
          IconButton(
              color: Hexcolor('#F4AA33'),
              icon: Icon(Icons.send, size: 38.0),
              onPressed: () => _onSendMessage(_textController.text)),
        ],
      ),
    );
  }

  // For each message bubble
  Widget buildMessage(DocumentSnapshot document, BuildContext context) {
    if (document['fromID'] != user.uid) {
      toggleUnread(document);
    }
    bool isUser = document['fromID'] == user.uid;
    // Format time to readable HH:MM
    var formatter = new DateFormat('Hm');
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(document['timestamp']));
    Widget time = Text(formatter.format(date),
        style: TextStyle(fontSize: 12.0, color: Colors.grey));
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              isUser
                  ? Row(
                      children: <Widget>[time, SizedBox(width: 10.0)],
                    )
                  : Container(),
              Container(
                padding: const EdgeInsets.all(15.0),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                decoration: BoxDecoration(
                  color: isUser ? Colors.white : Hexcolor("#F4AA33"),
                  borderRadius: isUser
                      ? BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomLeft: Radius.circular(25),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        ),
                ),
                child: Text(document['text'],
                    style: TextStyle(
                        color: isUser ? Colors.black : Colors.white,
                        fontSize: 14)),
              ),
              !isUser
                  ? Row(
                      children: <Widget>[SizedBox(width: 10.0), time],
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
