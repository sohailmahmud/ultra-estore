import 'package:flutter/material.dart';
import 'package:flutter_grocery/provider/chat_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MessageBubbleShimmer extends StatelessWidget {
  final bool isMe;

  MessageBubbleShimmer({@required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe ? EdgeInsets.fromLTRB(50, 5, 10, 5) : EdgeInsets.fromLTRB(10, 5, 50, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: Provider.of<ChatProvider>(context).chatList == null,
              child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: isMe ? Radius.circular(10) : Radius.circular(0),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: isMe ? ColorResources.getHintColor(context) : ColorResources.getGreyColor(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
