// lib/presentation/video_player_screen.dart

import 'package:flutter/material.dart';
// Note: Uncomment this after adding the video_player package
// import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  // late VideoPlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();

    // Simulating the time it takes a video to buffer and load
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isPlayerReady = true;
        });
      }
    });

    /* --- REAL IMPLEMENTATION ONCE YOU HAVE THE PACKAGE ---
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {
          _isPlayerReady = true;
        });
        _controller.play(); // Auto-play when ready
      });
    */
  }

  @override
  void dispose() {
    // _controller.dispose(); // Always dispose of the controller to free up memory
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // The actual video player
          Center(
            child: _isPlayerReady
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_circle_outline, size: 64, color: Colors.white),
                      SizedBox(height: 16),
                      Text('Video is Playing...', style: TextStyle(color: Colors.white)),
                    ],
                  )
                // Real implementation: AspectRatio(aspectRatio: _controller.value.aspectRatio, child: VideoPlayer(_controller))
                : const CircularProgressIndicator(color: Colors.purpleAccent),
          ),

          // Back button overlaid on top left
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 32),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
      floatingActionButton: _isPlayerReady
          ? FloatingActionButton(
              backgroundColor: Colors.purpleAccent,
              onPressed: () {
                // Real implementation:
                // setState(() {
                //   _controller.value.isPlaying ? _controller.pause() : _controller.play();
                // });
              },
              child: const Icon(Icons.pause, color: Colors.white),
              // Replace with: _controller.value.isPlaying ? Icons.pause : Icons.play_arrow
            )
          : null,
    );
  }
}