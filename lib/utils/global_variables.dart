import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_me/screens/add_post_screen.dart';
import 'package:social_me/screens/feed_screen.dart';
import 'package:social_me/screens/profile_screen.dart';
import 'package:social_me/screens/saved_posts_screen.dart';
import 'package:social_me/screens/search_screen.dart';

const webScreenSize = 500;
List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const SavedPostsScreen(),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
String currentUserData = "";
