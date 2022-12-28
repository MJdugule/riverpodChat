import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_ui/res/utils/enums.dart';
import 'package:whatsapp_ui/res/widget/video_player_card.dart';

class DisplayChatType extends StatelessWidget {
  final String message;
  final ChatEnum type;
  const DisplayChatType({super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    return type == ChatEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : type == ChatEnum.audio
            ? IconButton(
              constraints: const BoxConstraints(
                minWidth: 120
              ),
              onPressed: () {}, icon: const Icon(Icons.play_circle))
            : type == ChatEnum.video
                ? VideoPlayerCard(videoUrl: message)
                : CachedNetworkImage(imageUrl: message);
  }
}
