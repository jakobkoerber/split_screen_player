import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplitScreenView extends StatefulWidget {
  const SplitScreenView({
    super.key,
    required this.controller,
    required this.controller2,
  });

  final VideoPlayerController controller;
  final VideoPlayerController controller2;

  @override
  State<StatefulWidget> createState() => _SplitScreenViewState();
}

class _SplitScreenViewState extends State<SplitScreenView> {
  double ratio = 0.5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: (ratio * 100).toInt(),
            child: AspectRatio(
              aspectRatio: widget.controller.value.aspectRatio,
              child: VideoPlayer(widget.controller),
            )),
        Draggable(
          feedback: Container(
            height: double.maxFinite,
            width: 5,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          axis: Axis.horizontal,
          onDragUpdate: (details) {
            setState(() {
              ratio = details.globalPosition.distance /
                  MediaQuery.sizeOf(context).width;
            });
          },
          child: Container(
            height: double.maxFinite,
            width: 5,
            decoration: const BoxDecoration(color: Colors.white),
          ),
        ),
        Expanded(
            flex: 100 - (ratio * 100).toInt(),
            child: AspectRatio(
              aspectRatio: widget.controller2.value.aspectRatio,
              child: VideoPlayer(widget.controller2),
            )),
      ],
    );
  }
}
