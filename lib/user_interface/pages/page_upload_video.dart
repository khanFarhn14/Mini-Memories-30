import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PageUploadVideo extends StatefulWidget {
  final String videoPath;
  const PageUploadVideo({super.key, required this.videoPath});

  @override
  State<PageUploadVideo> createState() => _PageUploadVideoState();
}

class _PageUploadVideoState extends State<PageUploadVideo> {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initVideoPlayer() async{
    try{
      _videoController = VideoPlayerController.file(File(widget.videoPath));
      await _videoController.initialize();
      _videoController.play();
      await _videoController.setLooping(true);
    }catch(exception){
      clearPrint("Exception in _initVideoPlayer: $exception");
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload", style: Theme.of(context).textTheme.headlineMedium,),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Video", style: Theme.of(context).textTheme.titleMedium,),
          
                const SizedBox(height: 24,),
          
                FutureBuilder(
                  future: _initVideoPlayer(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Text("Video is Loading...", style: Theme.of(context).textTheme.bodyMedium,);
                    }else if(snapshot.hasError){
                      return Text("An error occured", style: Theme.of(context).textTheme.bodyMedium,);
                    }else{
                      return AspectRatio(
                        aspectRatio: _videoController.value.aspectRatio,
                        child: VideoPlayer(_videoController),
                      );
                    }
                  }
                ),

                const SizedBox(height: 24,),

                ElevatedButton(
                  onPressed: (){},
                  child: Text("Upload", style: Theme.of(context).textTheme.labelMedium,)
                )


          
          
              ],
            ),
          ),
        ),
      )
    );
  }
}

// Used this for debugging
clearPrint(String message) => debugPrint(
    "-------------------------------- $message --------------------------------");