import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String uid;
  final String username;
  final String email;
  final String bio;
  final String profilePictureUrl;
  final List followers;
  final List following;

  const MUser({
    required this.uid,
    required this.username,
    required this.email,
    required this.bio,
    required this.profilePictureUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'email': email,
        'bio': bio,
        'profilePictureUrl': profilePictureUrl,
        'followers': followers,
        'following': following,
      };
  static MUser fromSnapshot(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return MUser(
      uid: snap['uid'],
      username: snap['username'],
      email: snap['email'],
      bio: snap['bio'],
      profilePictureUrl: snap['profilePictureUrl'],
      followers: snap['followers'],
      following: snap['following'],
    );
  }
}
