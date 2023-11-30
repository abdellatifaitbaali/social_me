import 'package:apptex_chat/apptex_chat.dart';
import 'package:flutter/material.dart';
import 'package:social_me/utils/colors.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key, required this.conversation});

  final ConversationModel conversation;

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final TextEditingController _controller = TextEditingController();
  //final ScrollController _scrollController = ScrollController();
  bool showUsers = false;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      backgroundColor: mobileBackgroundColor,
      conversationModel: widget.conversation,
      appBarBuilder: (ChatUserModel currentUser, ChatUserModel otherUser) {
        return AppBar(
          backgroundColor: mobileBackgroundColor,
          //leadingWidth: 50,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(otherUser.profileUrl ?? ''),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(otherUser.name),
            ],
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () {},
          //     icon: const Icon(Icons.more_vert),
          //   ),
          // ],
        );
      },
      typingWidget: defaultTypingArea(true, true),
      //     Padding(
      //   padding: const EdgeInsets.all(12.0),
      //   child: Row(
      //     children: [
      //       Expanded(
      //         child: TextFormField(
      //           controller: _controller,
      //           cursorColor: blueColor,
      //           decoration: InputDecoration(
      //             prefixIcon: const Icon(
      //               Icons.keyboard,
      //               color: secondaryColor,
      //             ),
      //             hintText: "Message...",
      //             hintStyle: const TextStyle(color: secondaryColor),
      //             border: OutlineInputBorder(
      //               borderSide: const BorderSide(
      //                 width: 1,
      //                 color: mobileSearchColor,
      //                 style: BorderStyle.solid,
      //               ),
      //               borderRadius: BorderRadius.circular(15),
      //             ),
      //             focusedBorder: OutlineInputBorder(
      //               borderSide: const BorderSide(
      //                 width: 0.5,
      //                 color: blueColor,
      //                 style: BorderStyle.solid,
      //               ),
      //               borderRadius: BorderRadius.circular(15),
      //             ),
      //             enabledBorder: OutlineInputBorder(
      //               borderSide: const BorderSide(
      //                 width: 1,
      //                 color: mobileSearchColor,
      //                 style: BorderStyle.solid,
      //               ),
      //               borderRadius: BorderRadius.circular(15),
      //             ),
      //             filled: true,
      //             fillColor: webBackgroundColor,
      //             contentPadding: const EdgeInsets.all(8),
      //           ),
      //           scrollController: _scrollController,
      //           keyboardType: TextInputType.multiline,
      //           maxLines: 1,
      //           onChanged: (value) {
      //             setState(() {});
      //           },
      //         ),
      //       ),
      //       const SizedBox(width: 10),
      //       InkWell(
      //         onTap: () async {
      //           AppTexChat.instance.sendTextMessage(_controller.text);
      //           _controller.clear();
      //         },
      //         child: Container(
      //           padding: const EdgeInsets.all(14.0),
      //           decoration: const BoxDecoration(
      //             color: blueColor,
      //             shape: BoxShape.circle,
      //           ),
      //           child: const Icon(
      //             Icons.send,
      //             size: 16,
      //             color: primaryColor,
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
