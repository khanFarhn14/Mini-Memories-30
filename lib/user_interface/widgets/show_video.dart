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
    _isPlayingNotifier.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    await _videoPlayerController.initialize();
    _videoPlayerController.play();
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
                const SizedBox(height: 24,),

                // Name
                  Text.rich(
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

                const SizedBox(height: 12,),
                
                AspectRatio(
                  aspectRatio: 9/16,
                  child: VideoPlayer(_videoPlayerController)
                ),
              ],
            );
          }
        },
      );   
  }
}