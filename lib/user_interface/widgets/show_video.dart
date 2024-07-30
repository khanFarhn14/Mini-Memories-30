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
  final ValueNotifier<bool> _isPlayingNotifier = ValueNotifier<bool>(false);


  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController.initialize();
    // _videoPlayerController.play();
    await _videoPlayerController.setLooping(true);
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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username: ${widget.username}', style: Theme.of(context).textTheme.bodyMedium,),

                const SizedBox(height: 12,),
                
                AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController)
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                  children: [
                    ValueListenableBuilder(
                      valueListenable: _isPlayingNotifier,
                      builder: (context, isPlaying, child) {
                        return ElevatedButton(
                          onPressed: (){
                            if(isPlaying) {
                              _isPlayingNotifier.value = false;
                              _videoPlayerController.pause();
                            }else{
                              _isPlayingNotifier.value = true;
                              _videoPlayerController.play();
                            }
                          }, 
                          child: isPlaying ? const Icon(Icons.pause) : const Icon(Icons.play_arrow)
                        );
                      }
                    ),
                  ],
                )
              ],
            );
          }
        },
      );   
  }
}