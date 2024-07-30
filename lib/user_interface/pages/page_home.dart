import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';

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

  _recordVideo() async{
    try{
      final ImagePicker picker = ImagePicker();
      final XFile? cameraVideo = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 15),
        preferredCameraDevice: CameraDevice.front,
      );
      if(cameraVideo == null){
        clearPrint("No Capture Null");
        return;
      }

      clearPrint("Video Capture: ${cameraVideo.path}");
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PageUploadVideo(videoPath: cameraVideo.path),
      );
      // ignore: use_build_context_synchronously
      Navigator.push(context, route);
    }catch(exception){
      clearPrint("Exception caught in _recordVideo: $exception");
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
          _recordVideo();
        },
        child: const Icon(
          Icons.video_camera_back_outlined
        ),
      ),
    );
  }
}