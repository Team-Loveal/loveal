import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:lovealapp/models/user.dart';
import 'package:lovealapp/services/database.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    //get userData from the DB
    final userData = Provider.of<UserData>(context);
    //get userID from auth
    final user = Provider.of<User>(context);

    print(user.uid);
    print(userData.uid);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 35,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/editProfile');
                  },
                ),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('John Smith, 28',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        Row(
                          children: <Widget>[
                            Icon(MdiIcons.mapMarker,
                                size: 18, color: Colors.grey),
                            Text('Tokyo, Japan',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey))
                          ],
                        ),
                      ]),
                ),
                Expanded(
                  child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          'https://mymodernmet.com/wp/wp-content/uploads/2017/01/animal-selfies-5.jpg')),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Occupation',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 5),
                  Text('High School Teacher', style: TextStyle(fontSize: 16))
                ]),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Interests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: OutlineButton(
                              child: Text("Yodeling",
                                  style: TextStyle(color: Colors.pink)),
                              onPressed: null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)))),
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: OutlineButton(
                              child: Text("Skiing",
                                  style: TextStyle(color: Colors.pink)),
                              onPressed: null,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)))),
                    ],
                  )
                ]),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 80),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('About me',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 5),
                  Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                      style: TextStyle(fontSize: 16))
                ]),
          ),
        ],
      ),
    );
  }
}
