// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:progenuisadmin/utils/app_colors/app_colors.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class VideoPlayerPage extends StatefulWidget {
//   final String videoUrl;

//   VideoPlayerPage({required this.videoUrl});

//   @override
//   _VideoPlayerPageState createState() => _VideoPlayerPageState();
// }

// class _VideoPlayerPageState extends State<VideoPlayerPage> {
//   late YoutubePlayerController _youtubeController;
//   String? _videoId;

//   @override
//   void initState() {
//     super.initState();

//     // Extract the video ID from the YouTube URL
//     _videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

//     // If videoId is null, handle the error gracefully
//     if (_videoId != null) {
//       print(" YouTube URL ${widget.videoUrl}");
//       _youtubeController = YoutubePlayerController(
//         initialVideoId: _videoId!,
//         flags: YoutubePlayerFlags(
//           autoPlay: true,
//           mute: false,
//           disableDragSeek: false,
//           hideThumbnail: true,
//           controlsVisibleAtStart: true,
//           hideControls: false,
//           loop: false,
//           forceHD: true,
//         ),
//       );
//     } else {
//       // Handle error if videoId is not valid
//       print("Invalid YouTube URL");
//     }
//   }

//   @override
//   void dispose() {
//     _youtubeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {

//   //  print('=====URL=====${widget.videoUrl}');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Video Player',
//           style: TextStyle(color: AppColors.whitColor),
//         ),
//         backgroundColor: AppColors.secondary,
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: Icon(Icons.arrow_back_ios, color: AppColors.whitColor),
//         ),
//       ),
//       body: _videoId == null
//           ? Center(
//               child: Text(
//                 'Invalid video URL',
//                 style: TextStyle(fontSize: 18, color: Colors.red),
//               ),
//             )
//           : YoutubePlayerBuilder(
//               player: YoutubePlayer(
//                 controller: _youtubeController,
//                 showVideoProgressIndicator: true,
//                 progressIndicatorColor: Colors.red,
//                 onReady: () {
//                   print('YouTube Player is ready');
//                 },
//               ),
//               builder: (context, player) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Display the player
//                     player,
//                     const SizedBox(height: 16),
//                     // Additional controls or content can go here
//                   ],
//                 );
//               },
//             ),
            
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progenuisadmin/utils/app_colors/app_colors.dart';

import 'package:youtube_player_iframe/youtube_player_iframe.dart';


class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;

  VideoPlayerPage({required this.videoUrl});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;


  @override
  void initState() {
    super.initState();
  
    _initializePlayer();
  }

  void _initializePlayer() {
    try {
      final videoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);
      
      if (videoId == null) {
        throw Exception('Invalid YouTube URL: ${widget.videoUrl}');
      }

      _controller = YoutubePlayerController(
        params: const YoutubePlayerParams(
          // These are the correct parameter names for version 9.1.1
        //  startAt: Duration(seconds: 0),
          showControls: true,
          showFullscreenButton: true,
          // desktopMode: false,
          // privacyEnhanced: false,
          // useHybridComposition: true,
          // autoPlay: true,
          mute: false,
          loop: false,
          enableCaption: true,
          
          showVideoAnnotations: false,
          strictRelatedVideos: false,
        ),
      )..loadVideoById(videoId: videoId);

    } catch (e) {
      print('Error initializing YouTube player: $e');
      // You might want to show an error to the user here
    }
  }

  @override
  void dispose() {
  
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Video Player',
          style: TextStyle(color: AppColors.whitColor),
        ),
        backgroundColor: AppColors.secondary,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: AppColors.whitColor),
        ),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          aspectRatio: 16 / 10,
        ),
      ),
    );
  }
}