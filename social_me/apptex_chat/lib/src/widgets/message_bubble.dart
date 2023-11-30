import 'package:apptex_chat/src/core/utils/utils.dart';
import 'package:apptex_chat/src/utils/colors.dart';
import 'package:apptex_chat/src/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:apptex_chat/src/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel model;
  final bool wasPreviousMsgeMine;
  const MessageBubble({
    Key? key,
    required this.model,
    this.wasPreviousMsgeMine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 10;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          model.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!model.isMine)
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8, top: 6),
            child: ProfilePic(model.sender.profileUrl ?? ''),
          ),
        IntrinsicWidth(
            child: Container(
          constraints: BoxConstraints(
            minHeight: 30,
            maxWidth: MediaQuery.of(context).size.width * 0.65,
            minWidth: MediaQuery.of(context).size.width * 0.25,
          ),
          margin: const EdgeInsets.only(
            top: 6,
          ),
          decoration: BoxDecoration(
            color: model.isMine ? mobileSearchColor : blueColor,
            borderRadius: BorderRadius.all(
              Radius.circular(radius),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 8, top: 8, bottom: 6),
                child: Text(
                  model.content,
                  style: TextStyle(
                      fontFamily: 'Helvetica Neue',
                      color: primaryColor,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 2, left: 12),
                  child: Text(
                    getFormatedDayAndTime(model.createdOn),
                    style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 10,
                        color: greyColor,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              )
            ],
          ),
        )),
        if (model.isMine)
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 8, top: 6),
            child: ProfilePic(model.sender.profileUrl ?? ''),
          ),
      ],
    );
  }
}
