import 'package:flutter/material.dart';
import 'package:video_cached_player/video_cached_player.dart';

class VideoPlayerCard extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerCard({super.key, required this.videoUrl});

  @override
  State<VideoPlayerCard> createState() => _VideoPlayerCardState();
}

class _VideoPlayerCardState extends State<VideoPlayerCard> {
  late CachedVideoPlayerController videoPlayerController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    videoPlayerController = CachedVideoPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        videoPlayerController.setVolume(1);
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(videoPlayerController),
          Align(
            alignment: Alignment.center,
            child: IconButton(onPressed: () {
              if (isPlaying) {
                videoPlayerController.pause();
              }else{
                videoPlayerController.play();
              }

              setState(() {
                isPlaying = !isPlaying;
              });
            }, icon:  Icon(isPlaying ? Icons.pause_circle: Icons.play_circle)),
          )
        ],
      ),
    );
  }
}
