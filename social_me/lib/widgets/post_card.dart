// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/providers/user_provider.dart';
import 'package:social_me/resources/firestore_methods.dart';
import 'package:social_me/screens/comment_screen.dart';
import 'package:social_me/utils/colors.dart';
import 'package:social_me/utils/global_variables.dart';
import 'package:social_me/utils/utils.dart';
import 'package:social_me/widgets/like_animation.dart';
import 'package:social_me/widgets/save_animation.dart';

class PostCard extends StatefulWidget {
  final snapshot;
  const PostCard({Key? key, required this.snapshot}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;
  int commentCount = 0;
  String postId = "";
  bool isMine = false;

  void getComments() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snapshot['pid'])
          .collection('comments')
          .get();
      var userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snapshot['pid'])
          .get();
      currentUserData = userSnapshot.data()!['uid'].toString();
      if (postSnapshot['uid'].toString() == currentUserData) {
        isMine = true;
      } else {
        isMine = false;
      }
      commentCount = snapshot.docs.length;
      //print("${isMine.toString()} / ${currentUserData} / ${userSnapshot.data()!['uid'].toString()} / heeeere !!!!!!!");
    } catch (error) {
      showSnackBar(error.toString(), context);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getComments();
  }

  @override
  Widget build(BuildContext context) {
    final MUser user = Provider.of<UserProvider>(context).getUser;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: MediaQuery.of(context).size.width > webScreenSize
              ? secondaryColor
              : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(widget.snapshot['profilePictureUrl']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snapshot['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isMine
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shrinkWrap: true,
                                children: [
                                  "delete",
                                ]
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          FirestoreMethods().deletePost(
                                              widget.snapshot['pid']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: primaryColor,
                        ),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: Text(""),
                      ),
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                widget.snapshot['pid'],
                user.uid,
                widget.snapshot['likes'],
              );
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: double.infinity,
                  child: Image.network(
                    widget.snapshot['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 160),
                  opacity: isAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isAnimating,
                    duration: const Duration(milliseconds: 300),
                    onEnd: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: primaryColor,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snapshot['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snapshot['pid'],
                      user.uid,
                      widget.snapshot['likes'],
                    );
                  },
                  icon: widget.snapshot['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.favorite_rounded,
                        ),
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(top: 5),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentScreen(
                      snapshot: widget.snapshot,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.mode_comment,
                  size: 20,
                ),
              ),
              Transform.rotate(
                angle: -100 / 180,
                child: IconButton(
                  padding: const EdgeInsets.only(bottom: 3),
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: SaveAnimation(
                    isAnimating: widget.snapshot['saves'].contains(user.uid),
                    smallSave: true,
                    child: IconButton(
                      onPressed: () async {
                        await FirestoreMethods().savePost(
                          widget.snapshot['pid'],
                          user.uid,
                          widget.snapshot['saves'],
                        );
                      },
                      icon: widget.snapshot['saves'].contains(user.uid)
                          ? Icon(
                              Icons.bookmark,
                              color: blueColor,
                            )
                          : Icon(
                              Icons.bookmark_border_rounded,
                              color: primaryColor,
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text(
                    '${widget.snapshot['likes'].length} likes',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: primaryColor,
                      ),
                      children: [
                        TextSpan(
                          text: widget.snapshot['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                        ),
                        TextSpan(
                          text: widget.snapshot['caption'],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        snapshot: widget.snapshot,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'view all $commentCount comments',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snapshot['publishDate'].toDate(),
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
