import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lovealapp/models/user.dart';
import 'package:lovealapp/services/auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'message.dart';

class Match extends StatefulWidget {
  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  String matchID;
  String chatID;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final user = Provider.of<User>(context);
    final userData = Provider.of<UserData>(context);

    //check if matchedToday is true or false
    //if true then don't get new match
    //if false get new match

    print('MATCHED TODAY FROM DB ${userData.matchedToday}');
    print('I AM MATCHID $matchID');
    print('I AM USERID ${userData.nickname}');

    //find a user where chatted is false
    Firestore.instance
        .collection("messages")
        .where('fromID', isEqualTo: user.uid)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) => {
              //change this to !doc['matched']
              if (!doc['chatted'])
                {matchID = doc['toID'], chatID = doc.documentID}
            }));

    //set matched to true in messages collection
    Firestore.instance
        .collection("messages")
        .document(chatID)
        .updateData({'matched': true});

    //set matchedToday to true
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .updateData({'matchedToday': true});

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Row(
                children: <Widget>[
                  Text("Today's Match",
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      )),
                  //Adding logout icon to header
                  FlatButton.icon(
                    icon: Icon(Icons.person),
                    label: Text("logout"),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0),
//             width: 380,
//             height: 380,
            child: Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
//                    Container(
//                      child: Column(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          crossAxisAlignment: CrossAxisAlignment.start,
//                          children: <Widget>[
//                            Text('${userData.nickname}, ${userData.age}',
//                                style: TextStyle(
//                                    fontSize: 28, fontWeight: FontWeight.bold)),
//                            Row(
//                              children: <Widget>[
//                                Icon(MdiIcons.mapMarker,
//                                    size: 18, color: Colors.grey),
//                                Text('${userData.location}, Japan',
//                                    style: TextStyle(
//                                        fontWeight: FontWeight.bold,
//                                        color: Colors.grey))
//                              ],
//                            ),
//                          ]),
//                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 380,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                              'https://cdn.nybooks.com/wp-content/uploads/2018/05/foujita-self-portrait1.jpg',
                              fit: BoxFit.cover),
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 380,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                  color: Colors.black.withOpacity(0))),
                        )),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                      height: 80,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(35, 5, 0, 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              child: Text("John Smith, 28",
                                  style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: <Widget>[
                                Icon(MdiIcons.mapMarker,
                                    size: 18, color: Colors.pink),
                                Text('Tokyo, Japan',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.pink))
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(60, 5, 60, 0),
            child: ButtonTheme(
              height: 40.0,
              child: RaisedButton(
                  child: Text('Start a conversation',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                  color: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onPressed: () => {
                        print('THIS IS CHATID FROM MATCH.DART $chatID'),
                        print('THIS IS MATCHID FROM MATCH.DART $matchID'),
                        //set chatted to true in db
                        Firestore.instance
                            .collection("messages")
                            .document(chatID)
                            .updateData({'chatted': true}),

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Message(chatRoomID: chatID)))
                      }),
            ),
          ),
        ],
      ),
    );
  }
}
