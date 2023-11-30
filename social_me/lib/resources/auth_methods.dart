import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:social_me/models/user.dart' as model;
import 'package:social_me/resources/storage_methods.dart';

class AuthMethods {
  final String? uid;
  AuthMethods({this.uid});
  static final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // reference for our collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  Future<model.MUser> getUserDetails() async {
    User currentUser = auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.MUser.fromSnapshot(snapshot);
  }

  Future<String> signupUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Error Sign Up";
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          file.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //print(cred.user!.uid);
        String picUrl = await StorageMethods()
            .uploadImageToStorage('ProfilePictures', file, false);

        model.MUser user = model.MUser(
          uid: cred.user!.uid,
          username: username,
          email: email,
          bio: bio,
          profilePictureUrl: picUrl,
          followers: [],
          following: [],
        );
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = "success";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error log In";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } else {
        res = "All the fields are required";
      }
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
