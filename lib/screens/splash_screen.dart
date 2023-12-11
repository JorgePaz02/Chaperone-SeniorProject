import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
    void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('lib/assets/splash_video.mp4')
      ..initialize().then((_) {
        if (this.mounted) {
          setState(() {
            _isVideoInitialized = true;
            _controller.play();
            Future.delayed(const Duration(seconds: 5), () {
              // Navigate to the main screen
              Navigator.pushReplacementNamed(context, '/mainscreen');
            });
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // don't forget to dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _isVideoInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : Container(
                  color: Colors.black,
                ),
        ],
      ),
    );
  }
}
