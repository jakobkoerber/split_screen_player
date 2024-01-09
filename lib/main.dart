import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:test/split_screen_view.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: SafeArea(child: _BumbleBeeRemoteVideo()),
        backgroundColor: Colors.black,
      ),
    ),
  );
}

class _BumbleBeeRemoteVideo extends StatefulWidget {
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  late VideoPlayerController _controller;
  //late VideoPlayerController _controller2;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'),
      Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    /*
    _controller2 = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    */
    _controller.addListener(() async {
      setState(() {});
    });
    _controller.setLooping(true);
    /*_controller2.addListener(() {
      setState(() {});
    });
    _controller2.setVolume(0.0);
    _controller2.setLooping(true);*/
    _controller.initialize();
    _controller.play();
    //Future.wait([_controller.initialize(), _controller2.initialize()]);
  }

  @override
  void dispose() {
    _controller.dispose();
    //_controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SplitScreenView(controller: _controller/*, controller2: _controller2*/),
        ClosedCaption(text: _controller.value.caption.text),
        _ControlsOverlay(
          controller: _controller,
          //controller2: _controller2,
        ),
        VideoProgressIndicator(_controller,
            /*controller2: _controller2,*/ allowScrubbing: true),
      ],
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({
    required this.controller,
    //required this.controller2,
  });

  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;
  //final VideoPlayerController controller2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            /*if (controller.value.isInitialized &&
                controller2.value.isInitialized) {
              if (controller.value.isPlaying && controller2.value.isPlaying) {
                Future.wait([controller.pause(), controller2.pause()]);
              } else {
                Future.wait([controller.play(), controller2.play()]);
              }
            }*/
            controller.value.isPlaying ? controller.play() : controller.pause();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              //Future.wait([
                controller.setPlaybackSpeed(speed);//,
                //controller2.setPlaybackSpeed(speed)
              //]);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text(
                      '${speed}x',
                    ),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x',
                  style: const TextStyle(
                    color: Colors.white,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
