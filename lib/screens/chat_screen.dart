import 'package:apptex_chat/apptex_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_me/models/user.dart';
import 'package:social_me/screens/inbox_screen.dart';
import 'package:social_me/utils/colors.dart';
import 'package:social_me/utils/global_variables.dart';
import 'package:time_elapsed/time_elapsed.dart';

class MChatScreen extends StatefulWidget {
  const MChatScreen({super.key});

  @override
  State<MChatScreen> createState() => _MChatScreenState();
}

class _MChatScreenState extends State<MChatScreen> {
  late TextEditingController _controller;
  bool showSendButton = false;
  final TextEditingController searchController = TextEditingController();
  //final ScrollController _scrollController = ScrollController();
  bool showUsers = false;
  bool userExists = false;
  int i = 0;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Messages"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: TextFormField(
              controller: searchController,
              cursorColor: secondaryColor,
              decoration: InputDecoration(
                fillColor: webBackgroundColor,
                hintText: "Search for a friend",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: mobileSearchColor,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5,
                    color: blueColor,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 0.5,
                    color: mobileSearchColor,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                contentPadding: const EdgeInsets.all(8),
              ),
              onChanged: (String val) {
                setState(() {
                  if (val.isNotEmpty) {
                    showUsers = true;
                  } else {
                    showUsers = false;
                  }
                });
              },
            ),
          ),
          showUsers
              ? Expanded(
                  child: ConversationsScreen(
                    builder: (conversations, isLoading) {
                      for (var index = 0;
                          index < conversations.length;
                          index++) {
                        if (conversations[index].otherUser.name.toString() ==
                            searchController.text) {
                          userExists = true;
                          i = index + 1;
                          break;
                        } else {
                          userExists = false;
                        }
                      }

                      if (userExists) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: mobileBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                  color: mobileSearchColor.withOpacity(0.8),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1))
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 0,
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 5,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InboxScreen(
                                    conversation: conversations[i - 1],
                                  ),
                                ),
                              );
                              // AppTexChat.instance.startNewConversationWith();
                            },
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  conversations[i - 1].otherUser.profileUrl ??
                                      ''),
                            ),
                            title: SizedBox(
                              height: 20,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      conversations[i - 1].otherUser.name,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: SizedBox(
                              height: 30,
                              child: Text(
                                conversations[i - 1].lastMessage,
                                style: TextStyle(
                                  fontWeight:
                                      conversations[i - 1].unreadMessageCount >
                                                  0 &&
                                              !conversations[i - 1]
                                                  .isLastMessageMine
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      conversations[i - 1].unreadMessageCount >
                                                  0 &&
                                              !conversations[i - 1]
                                                  .isLastMessageMine
                                          ? primaryColor
                                          : secondaryColor,
                                ),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                conversations[i - 1].unreadMessageCount > 0 &&
                                        !conversations[i - 1].isLastMessageMine
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: blueColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          conversations[i - 1]
                                              .unreadMessageCount
                                              .toString(),
                                          style: TextStyle(color: primaryColor),
                                        ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  getTimeLaps(
                                    time: conversations[i - 1]
                                        .lastMessageTime
                                        .toDate(),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("No conversations yet"),
                        );
                      }
                    },
                  ),
                )
              : Expanded(
                  child: ConversationsScreen(
                    builder: (conversations, isLoading) {
                      if (conversations.isEmpty) {
                        return const Center(
                            child: Text("No conversations yet"));
                      }

                      return ListView.separated(
                        separatorBuilder: (ctx, index) => Divider(
                          thickness: 0,
                          height: 8,
                          color: mobileBackgroundColor,
                        ),
                        itemCount: conversations.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: mobileBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                    color: mobileSearchColor.withOpacity(0.8),
                                    spreadRadius: 1,
                                    blurRadius: 4,
                                    offset: const Offset(0, 1))
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 0,
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 3,
                              horizontal: 5,
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InboxScreen(
                                      conversation: conversations[index],
                                    ),
                                  ),
                                );
                                // AppTexChat.instance.startNewConversationWith();
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    conversations[index].otherUser.profileUrl ??
                                        ''),
                              ),
                              title: SizedBox(
                                height: 20,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        conversations[index].otherUser.name,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: SizedBox(
                                height: 30,
                                child: Text(
                                  conversations[index].lastMessage,
                                  style: TextStyle(
                                    fontWeight: conversations[index]
                                                    .unreadMessageCount >
                                                0 &&
                                            !conversations[index]
                                                .isLastMessageMine
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: conversations[index]
                                                    .unreadMessageCount >
                                                0 &&
                                            !conversations[index]
                                                .isLastMessageMine
                                        ? primaryColor
                                        : secondaryColor,
                                  ),
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  conversations[index].unreadMessageCount > 0 &&
                                          !conversations[index]
                                              .isLastMessageMine
                                      ? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: blueColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            conversations[index]
                                                .unreadMessageCount
                                                .toString(),
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    getTimeLaps(
                                      time: conversations[index]
                                          .lastMessageTime
                                          .toDate(),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: mobileBackgroundColor,
        ),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (buildr) {
                return const SearchUserScreen();
              },
            ),
          )
        },
      ),
    );
  }
}

String getTimeLaps({required time}) {
  return TimeElapsed.fromDateStr(time.toString())
      .toCustomTimeElapsed(getTimeLapse());
}

getTimeLapse() {
  return CustomTimeElapsed(
    minutes: 'minutes',
    hours: 'hours',
    days: 'days',
    now: 'now',
    seconds: 'seconds',
    weeks: 'weeks',
  );
}

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  TextEditingController searchController = TextEditingController();

  List<MUser> users = [];
  bool isLoading = false;

  Future<void> searchUser({required String keyword}) async {
    users.clear();
    var userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    currentUserData = userSnapshot.data()!['username'].toString();
    final mUsersRef = FirebaseFirestore.instance.collection('users');
    final query = mUsersRef
        .orderBy("username")
        .where('username', isGreaterThanOrEqualTo: keyword)
        .where('username', isLessThan: '${keyword}z');

    setState(() {
      isLoading = true;
    });
    final querySnapshot = await query.get();
    final docs = querySnapshot.docs;

    users = docs
        .map((doc) {
          MUser user = MUser.fromSnapshot(doc);
          if (user.username == currentUserData) {
            return null;
          }
          return user;
        })
        .whereType<MUser>()
        .toSet()
        .toList();

    setState(() {
      isLoading = false;
    });
  }

  Widget searchWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        controller: searchController,
        cursorColor: secondaryColor,
        decoration: InputDecoration(
          fillColor: webBackgroundColor,
          hintText: "Search for a user",
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: mobileSearchColor,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: blueColor,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
              color: mobileSearchColor,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
        ),
        onChanged: (String? val) async {
          if (val != null && val.isNotEmpty) {
            await searchUser(keyword: val);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("New Conversation"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            searchWidget(),
            const SizedBox(height: 10.0),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 40,
                        width: 40.0,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : users.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                          color: primaryColor,
                        ))
                      : ListView.separated(
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(users[index].username),
                              onTap: () {
                                AppTexChat.instance
                                    .startNewConversationWith(
                                      ChatUserModel(
                                        uid: users[index].uid,
                                        profileUrl:
                                            users[index].profilePictureUrl,
                                        name: users[index].username,
                                        fcmToken:
                                            "${users[index].uid}${users[index].uid}",
                                      ),
                                    )
                                    .then(
                                      (mConv) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InboxScreen(
                                            conversation: mConv,
                                          ),
                                        ),
                                      ),
                                    );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ChatScreen(
//       conversationModel: widget.model,
//       showMicButton: true,
//       appBarBuilder: ((currentUser, otherUser) => AppBar()),
//       bubbleBuilder: (model, currentUser, otherUser, isMine) {
//         final code = model.code;
//         if (code == 'TXT') {
//           return MessageBubble(model: model);
//         } else if (code == 'IMG') {
//           return ImageBubble(model: model);
//         } else if (code == 'MP3') {
//           return AudioBubble(model: model);
//         } else {
//           return Container();
//         }
//       },
//     )
