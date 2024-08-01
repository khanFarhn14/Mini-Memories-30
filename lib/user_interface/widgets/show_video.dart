import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  final String url, username, createdAt;
  const ShowVideo({super.key, required this.url, required this.username, required this.createdAt});

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late VideoPlayerController _videoPlayerController;
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(true);


  @override
  void dispose() {
    _videoPlayerController.dispose();
    _isPlayingNotifier.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController.initialize();
    _videoPlayerController.play();
    await _videoPlayerController.setLooping(true);
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