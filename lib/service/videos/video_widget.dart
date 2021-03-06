import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  VideoWidget({Key key, this.pickedVideo, this.videoUrl}) : super(key: key);

  final File pickedVideo;
  final String videoUrl;

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    if (widget.pickedVideo != null) {
      _controller = VideoPlayerController.file(widget.pickedVideo)
        ..addListener(() => setState(() {}))
        ..initialize();
    } else {
      _controller = VideoPlayerController.network(widget.videoUrl)
        ..addListener(() => setState(() {}))
        ..initialize();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 120,
      width: 90,
      child: Stack(children: [
        VideoPlayer(_controller),
        const Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.play_circle_outline,
            color: Colors.white,
          ),
        )
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
