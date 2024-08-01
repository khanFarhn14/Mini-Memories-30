import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  final String url, username, createdAt;
  final int index;
  const ShowVideo({super.key, required this.url, required this.username, required this.createdAt, required this.index});

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late VideoPlayerController _videoPlayerController;
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    // clearPrint("Initializing video at index: ${widget.index}");
    super.initState();
  }
  @override
  void dispose() {
    // clearPrint("Disposing video at index: ${widget.index}");
    _videoPlayerController.dispose();
    _isPlayingNotifier.dispose();
    clearVideoPlayerCache();
    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController.initialize();
    _videoPlayerController.play();
    await _videoPlayerController.setLooping(true);
  }

  Future<void> clearVideoPlayerCache() async {
    final cacheDir = await getTemporaryDirectory();
    if (cacheDir.existsSync()) {
      clearPrint("cacheDir.exists init loop");
      cacheDir.listSync().forEach((file) {
        if (file is File && file.path.contains('libCachedVideoPlayer')) {
          clearPrint("Deleting something I don't know in the loop");
          file.deleteSync();
        }
      });
    }else{
      clearPrint("cacheDir doesnt exist");
    }
  }

  void _changeStateOfVideo() {
    if(_isPlayingNotifier.value){
      _videoPlayerController.pause();
      _isPlayingNotifier.value = false;
    }else{
      _videoPlayerController.play();
      _isPlayingNotifier.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if(state.hasError){
            return const Center(child: Text('Failed to load video'));
          }else{
            return Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(height: 24,),

                ValueListenableBuilder(
                  valueListenable: _isPlayingNotifier,
                  builder: (context, isPlaying, child) {
                    return InkWell(
                      onTap: (){
                        _changeStateOfVideo();
                      },
                      child: AspectRatio(
                        aspectRatio: _videoPlayerController.value.aspectRatio,
                        child: VideoPlayer(_videoPlayerController)
                      ),
                    );
                  }
                ),

                // Name
                Positioned(
                  bottom: 24,
                  left: 16,
                  child: Text.rich(
                    TextSpan(
                      text: 'username: ',
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: widget.username.toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium
                        )
                      ]
                    )
                  ),
                ),

                ValueListenableBuilder(
                  valueListenable: _isPlayingNotifier,
                  builder: (context, isPlaying, child) {
                    return Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      size: 58,
                      color: isPlaying ? Colors.transparent : Colors.white,
                    );
                  }
                )
              ],
            );
          }
        },
      );   
  }
}