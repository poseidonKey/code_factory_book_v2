import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;
  const CustomVideoPlayer({
    super.key,
    required this.video,
    required this.onNewVideoPressed,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  bool showControls = false;
  @override
  void initState() {
    super.initState();
    initializeController();
  }

  Future<void> initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );
    // final videoController =
    //     VideoPlayerController.asset('asset/video/sample.mp4');
    // final videoController = VideoPlayerController.networkUrl(
    //   Uri.parse('https://www.youtube.com/watch?v=S6y2S3tfMRQ'),
    // );

    await videoController.initialize();
    videoController.addListener(videoControllerListener);
    setState(() {
      videoPlayerController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(() {
      videoControllerListener();
    });
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoPlayerController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(
              videoPlayerController!,
            ),
            if (showControls)
              Container(
                //전체 뒷 player를 어둡게 처리
                color: Colors.black.withOpacity(.5),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(
                        videoPlayerController!.value.position),
                    Expanded(
                      child: Slider(
                        value: videoPlayerController!.value.position.inSeconds
                            .toDouble(),
                        onChanged: (double value) {
                          videoPlayerController!.seekTo(
                            Duration(
                              seconds: value.toInt(),
                            ),
                          );
                        },
                        min: 0,
                        max: videoPlayerController!.value.duration.inSeconds
                            .toDouble(),
                      ),
                    ),
                    renderTimeTextFromDuration(
                      videoPlayerController!.value.duration,
                    )
                  ],
                ),
              ),
            ),
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                    onPressed: widget.onNewVideoPressed,
                    iconData: Icons.photo_camera_back),
              ),
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: (videoPlayerController!.value.isPlaying)
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    CustomIconButton(
                      onPressed: onForwardPressed,
                      iconData: Icons.rotate_right,
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Text renderTimeTextFromDuration(Duration duration) {
    return Text(
      '${duration.inMinutes.toString().padLeft(2, '0')}:,${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
      style: const TextStyle(color: Colors.white),
    );
  }

  void onReversePressed() {
    final currentPosition = videoPlayerController!.value.position;
    Duration position = const Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - const Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;
    Duration position = maxPosition;
    if ((maxPosition - const Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
    setState(() {});
  }
}
