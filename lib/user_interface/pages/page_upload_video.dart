import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mini_memories_30/backend/upload_file.dart';
import 'package:video_player/video_player.dart';

class PageUploadVideo extends StatefulWidget {
  final String videoPath;
  const PageUploadVideo({super.key, required this.videoPath});

  @override
  State<PageUploadVideo> createState() => _PageUploadVideoState();
}

class _PageUploadVideoState extends State<PageUploadVideo> {
  late VideoPlayerController _videoController;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _videoTitleController = TextEditingController();

  final ValueNotifier<bool> _isUploaded = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _videoTitleController.dispose();
    super.dispose();
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

  Future<void> _uploadVideo() async {
    if (_formKey.currentState!.validate()) {
      _isUploaded.value = false;

      try {
        UploadFile uploadFile = UploadFile(
          context: context
        );

        Duration duration = _videoController.value.duration;

        await uploadFile.uploadVideo(
          username: 'farhan',
          videoPath: widget.videoPath,
          videoTitle: _videoTitleController.text,
          duration: duration.inSeconds
        );

      } on FirebaseException catch (e) {
        clearPrint("Firebase error during upload: ${e.code} - ${e.message}");
      } catch (exception) {
        clearPrint("Error during video upload: $exception");
      } finally {
        _isUploaded.value = true; 
      }
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
          child: ValueListenableBuilder(
            valueListenable: _isUploaded,
            builder: (context, isUploaded, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                child: isUploaded ?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _videoTitleController,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          labelText: 'Video Title',
                          border: OutlineInputBorder(),
                        ),
                        // validation
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'username cannot be empty';
                          }
                          return null;
                        },
                      )
                    ),
              
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
                      onPressed: (){
                        _uploadVideo();
                      },
                      child: Text("Upload", style: Theme.of(context).textTheme.labelMedium,)
                    )
              
                  ],
                ) : 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text("Video Uploading...", style: Theme.of(context).textTheme.headlineMedium,),
                    )
                  ],
                )
              );
            }
          ),
        ),
      )
    );
  }
}

// Used this for debugging
clearPrint(String message) => debugPrint(
    "-------------------------------- $message --------------------------------");