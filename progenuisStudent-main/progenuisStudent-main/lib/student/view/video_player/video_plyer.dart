import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenius/student/utils/appColors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:no_screenshot/no_screenshot.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  VideoPlayerPage({required this.videoUrl});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  final NoScreenshot _noScreenshot = NoScreenshot();
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _enableScreenshotProtection();

    _videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

    if (_videoId != null) {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: _videoId!,
        autoPlay: true,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          strictRelatedVideos: true,
        ),
      );
    } else {
      // Handle invalid URL case
       _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
        ),
      );
    }
  }

  Future<void> _enableScreenshotProtection() async {
    try {
      await _noScreenshot.screenshotOn(); // Enable protection (prevent screenshots)
    } catch (e) {
      debugPrint('Error enabling screenshot protection: $e');
    }
  }

  Future<void> _disableScreenshotProtection() async {
    try {
      await _noScreenshot.screenshotOff(); // Disable protection (allow screenshots)
    } catch (e) {
      debugPrint('Error disabling screenshot protection: $e');
    }
  }

  @override
  void dispose() {
    _disableScreenshotProtection();
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Video Player', style: TextStyle(color: AppColors.whitColor)),
          backgroundColor: AppColors.secondary,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios, color: AppColors.whitColor),
          ),
        ),
        body: Center(
          child: Text(
            'Invalid Video URL',
            style: TextStyle(color: Colors.red, fontSize: 18),
          ),
        ),
      );
    }

    return YoutubePlayerScaffold(
      controller: _controller,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Video Player',
              style: TextStyle(color: AppColors.whitColor),
            ),
            backgroundColor: AppColors.secondary,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios, color: AppColors.whitColor),
            ),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: player,
              );
            },
          ),
        );
      },
    );
  }
}