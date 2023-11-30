// ignore_for_file: prefer_typing_uninitialized_variables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:provider/provider.dart';
//import 'package:social_me/models/user.dart';
//import 'package:social_me/providers/user_provider.dart';
//import 'package:social_me/resources/firestore_methods.dart';

class CommentCard extends StatefulWidget {
  final snapshot;
  const CommentCard({Key? key, required this.snapshot}) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    //final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snapshot['profilePictureUrl']),
            radius: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: widget.snapshot['username'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: widget.snapshot['comment'],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snapshot['publishDate'].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(4),
          //   child: Column(
          //     children: [
          //       IconButton(
          //         onPressed: () async {
          //           await FirestoreMethods().likeComment(
          //             widget.snapshot['comments'].docs['commentId'],
          //             user.uid,
          //             widget.snapshot['likes'],
          //           );
          //         },
          //         icon: widget.snapshot['likes'].contains(user.uid)
          //             ? const Icon(
          //                 Icons.favorite_outlined,
          //                 color: Colors.red,
          //               )
          //             : const Icon(
          //                 Icons.favorite_border_rounded,
          //                 size: 16,
          //               ),
          //       ),
          //       Text(
          //         widget.snapshot['likes'].length.toString(),
          //         style: const TextStyle(fontSize: 12),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
