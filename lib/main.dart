import 'package:flutter/material.dart';
import 'package:lovealapp/pages/createProfile.dart';
import 'package:lovealapp/pages/editProfile.dart';
import 'package:lovealapp/pages/uploadphoto.dart';
import 'package:lovealapp/pages/login.dart';
import 'package:lovealapp/pages/signup.dart';
import 'package:lovealapp/pages/profilePreview.dart';

//main function is the first function that fires when dart file starts
void main() {
  runApp(MyApp());
}

//create new widget called MyApp which is the root widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Material App is a widget that has properties like title, theme etc.
    return MaterialApp(
      title: 'Loveal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      //what widget should load on the home screen
//      home: CreateProfile(),
      //wh: upload_pat widget should load on the home screen
      home: CreateProfile(),
    );
  }
}
