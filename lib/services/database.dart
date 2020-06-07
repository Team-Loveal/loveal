import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference usersCollection =
      Firestore.instance.collection("users");

  //set user data when signing up
  Future setUserData(String email) async {
    return await usersCollection.document(uid).setData({
      'email': email,
      'nickname': "",
      'location': "",
      'age': "",
      'gender': "",
      'occupation': "",
      'about': "",
      "interests": "",
    });
  }

  //update user data when creating profile or editing profile
  Future updateUserData(String nickname, String location, String age,
      String gender, String occupation, String about, String interests) async {
    return await usersCollection.document(uid).updateData({
      'nickname': nickname,
      'location': location,
      'age': age,
      'gender': gender,
      'occupation': occupation,
      'about': about,
      "interests": interests,
    });

  //Creating chat rooms
    //This is probably wrong
  createChatRoom(String chatRoomID) {
    Firestore.instance.collection("messages")
        .document(chatRoomID);
  }

  }

  //get users doc stream
  //prob useful when populating user data in preview profile and edit profile
  Stream<QuerySnapshot> get userData {
    return usersCollection.snapshots();
  }
}
