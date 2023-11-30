import 'package:apptex_chat/apptex_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_me/resources/auth_methods.dart';
import 'package:social_me/screens/chat_screen.dart';
import 'package:social_me/utils/colors.dart';
import 'package:social_me/utils/global_variables.dart';
import 'package:social_me/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late PageController pageController;

  var apptexChat = AppTexChat.instance;

  late ChatUserModel chatUser;

  initChatUser(User user) async {
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    chatUser = ChatUserModel(
      uid: user.uid,
      profileUrl: userSnapshot.data()!["profilePictureUrl"],
      name: userSnapshot.data()!["username"],
      fcmToken: "${user.uid}${user.uid}",
    );

    apptexChat.initChat(currentUser: chatUser);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    initChatUser(AuthMethods.auth.currentUser!);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MediaQuery.of(context).size.width > webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_socialme.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                Transform.rotate(
                  angle: -100 / 180,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MChatScreen(),
                        ), /////////////////////////////////////
                      );
                    },
                    icon: Icon(
                      Icons.send_rounded,
                      color: primaryColor,
                    ),
                  ),
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('publishDate', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 10 : 0,
              ),
              child: PostCard(
                snapshot: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
