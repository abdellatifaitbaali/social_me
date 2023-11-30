// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String pid;
  final String username;
  final String caption;
  final DateTime publishDate;
  final String postUrl;
  final String profilePictureUrl;
  final likes;
  final saves;

  const Post({
    required this.uid,
    required this.pid,
    required this.username,
    required this.caption,
    required this.publishDate,
    required this.postUrl,
    required this.profilePictureUrl,
    required this.likes,
    required this.saves,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'pid': pid,
        'username': username,
        'caption': caption,
        'publishDate': publishDate,
        'postUrl': postUrl,
        'profilePictureUrl': profilePictureUrl,
        'likes': likes,
        'saves': saves,
      };
  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Post(
      uid: snap['uid'],
      pid: snap['pid'],
      username: snap['username'],
      caption: snap['caption'],
      publishDate: snap['PublishDate'],
      postUrl: snap['postUrl'],
      profilePictureUrl: snap['profilePictureUrl'],
      likes: snap['likes'],
      saves: snap['saves'],
    );
  }
}
