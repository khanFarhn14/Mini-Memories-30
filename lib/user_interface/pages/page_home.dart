import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';
import 'package:mini_memories_30/user_interface/widgets/components.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _recordVideo() async{
    try{
      final ImagePicker picker = ImagePicker();

      await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 15),
        preferredCameraDevice: CameraDevice.front,
      ).then((value){
          if(value != null){
            Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => PageUploadVideo(videoPath: value.path),
              )
            );
          }
        }
      );
      
    }catch(exception){
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("This is Feed Page"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _recordVideo().onError((error, stackTrace){
              Components.showSnackBarForFeedback(
                context: context, 
                message: 'Exception when recording video: $error',
                isError: true
              );
            }
          );
        },
        child: const Icon(
          Icons.video_camera_back_outlined
        ),
      ),
    );
  }
}