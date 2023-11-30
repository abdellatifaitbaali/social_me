import 'package:apptex_chat/src/screens/full_screen_image.dart';
import 'package:apptex_chat/src/utils/colors.dart';
import 'package:apptex_chat/src/widgets/profile_picture.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/utils/utils.dart';
import '../models/message_model.dart';

class ImageBubble extends StatelessWidget {
  final MessageModel model;
  final bool wasPreviousMsgeMine;
  const ImageBubble({
    Key? key,
    required this.model,
    this.wasPreviousMsgeMine = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double radius = 10;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
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
                  padding: const EdgeInsets.all(4),
                  child: model.content.isEmpty
                      ? Container(
                          width: 240,
                          height: 240,
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: greyColor,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(radius),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(
                                    imgUrl: model.content,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                              tag: model.content,
                              transitionOnUserGestures: true,
                              child: CachedNetworkImage(
                                imageUrl: model.content,
                                fit: BoxFit.cover,
                                width: 240,
                                height: 260,
                                placeholder: (context, url) => Container(
                                  color: secondaryColor,
                                  width: 240,
                                  height: 260,
                                  margin: EdgeInsets.zero,
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: secondaryColor,
                                  width: 240,
                                  height: 260,
                                  margin: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          )),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 2),
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
          ),
        ),
        if (model.isMine)
          Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 8, top: 6),
            child: ProfilePic(model.sender.profileUrl ?? ''),
          ),
      ],
    );
  }
}
