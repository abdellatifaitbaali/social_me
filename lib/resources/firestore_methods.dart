// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:social_me/models/post.dart';
import 'package:social_me/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String uid,
    String username,
    String caption,
    String profilePictureUrl,
    Uint8List file,
  ) async {
    String res = "Error uploading post image";
    try {
      String pictureUrl =
          await StorageMethods().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();
      Post post = Post(
        uid: uid,
        pid: postId,
        username: username,
        caption: caption,
        publishDate: DateTime.now(),
        postUrl: pictureUrl,
        profilePictureUrl: profilePictureUrl,
        likes: [],
        saves: [],
      );
      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (error) {
      res = error.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> savePost(String postId, String uid, List saves) async {
    try {
      if (saves.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'saves': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> likeComment(String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('comments').doc(commentId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> commentToPost(
    String postId,
    String comment,
    String uid,
    String username,
    String profilePictureUrl,
  ) async {
    try {
      if (comment.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePictureUrl': profilePictureUrl,
          'uid': uid,
          'username': username,
          'commentId': commentId,
          'comment': comment,
          'publishDate': DateTime.now(),
          'likes': [],
          'saves': [],
        });
      } else {
        print("comment field is empty!");
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> followUnfollow(String userId, String targerId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(userId).get();
      List following = (snapshot.data()! as dynamic)['following'];
      if (following.contains(targerId)) {
        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayRemove([targerId]),
        });
        await _firestore.collection('users').doc(targerId).update({
          'followers': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayUnion([targerId]),
        });
        await _firestore.collection('users').doc(targerId).update({
          'followers': FieldValue.arrayUnion([userId]),
        });
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> sendMessage(
    String cId,
    String sender,
    String receiver,
    String message,
  ) async {
    try {
      if (message.isNotEmpty) {
        String cId = const Uuid().v1();
        await _firestore.collection('conversations').doc(cId).set({
          'sender': sender,
          'receiver': receiver,
          'message': message,
          'sendingDate': DateTime.now(),
        });
      } else {
        print("comment field is empty!");
      }
    } catch (error) {
      print(error.toString());
    }
  }
}
