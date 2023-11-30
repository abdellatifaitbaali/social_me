import 'package:apptex_chat/src/screens/messages/chat_view_model.dart';
import 'package:apptex_chat/src/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

class EmojiPickerSheet extends StatelessWidget {
  const EmojiPickerSheet({
    Key? key,
    required this.textEditingController,
    required this.model,
  }) : super(key: key);
  final TextEditingController textEditingController;
  final ChatViewModel model;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: EmojiPicker(
        onEmojiSelected: (Category? category, Emoji emoji) {
          model.showSendButton = true;
          model.update();
        },
        textEditingController:
            textEditingController, // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
        config: Config(
          columns: 8,

          emojiSizeMax: 32 *
              (foundation.defaultTargetPlatform == TargetPlatform.iOS
                  ? 1.30
                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          gridPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          initCategory: Category.RECENT,
          bgColor: mobileBackgroundColor,
          indicatorColor: blueColor,
          iconColor: secondaryColor,
          iconColorSelected: blueColor,
          backspaceColor: blueColor,
          skinToneDialogBgColor: mobileBackgroundColor,
          skinToneIndicatorColor: secondaryColor,
          enableSkinTones: true,
          recentsLimit: 28,
          noRecents: const Text(
            'No Recents',
            style: TextStyle(fontSize: 20, color: Colors.black26),
            textAlign: TextAlign.center,
          ), // Needs to be const Widget
          loadingIndicator: const SizedBox.shrink(), // Needs to be const Widget
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),

          buttonMode: ButtonMode.MATERIAL,
        ),
      ),
    );
  }
}
