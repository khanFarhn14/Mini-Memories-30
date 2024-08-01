import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_memories_30/backend/fetch_file.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';
import 'package:mini_memories_30/user_interface/widgets/components.dart';
import 'package:mini_memories_30/user_interface/widgets/show_video.dart';
import 'package:video_compress/video_compress.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {

  final FetchFile _fetchFile = FetchFile();
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _recordVideo() async{
    try{
      _isLoadingNotifier.value = true;
      final ImagePicker picker = ImagePicker();

      final videoFile = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 15),
        preferredCameraDevice: CameraDevice.front,
      );

      if(videoFile != null){
        await compressVideo(videoFile.path).then((value) async{
            value != null ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PageUploadVideo(videoPath: value)
              )
            ) : Components.showSnackBarForFeedback(
              context: context,
              message: 'Null value is returned',
              isError: true
            );
          }
        );
        // await videoFile.length().then((value){
        //     String fileSize = getFileSize(value, 2);
        //     clearPrint("Size of the file: $fileSize");
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => PageUploadVideo(videoPath: videoFile.path),
        //       )
        //     );
        //   }
        // );
      }

    }catch(exception){
      rethrow;
    }finally{
      _isLoadingNotifier.value = false;
    }
  }

  Future<String?> compressVideo(String videoPath) async {
    try {
      final MediaInfo mediaInfo = await VideoCompress.getMediaInfo(videoPath);
      
      if (mediaInfo.path == null) {
        clearPrint('Failed to get media info');
        return null;
      }

      // Check if the video exceeds 1920x1080
      if (mediaInfo.width! > 1920 || mediaInfo.height! > 1080) {
        final MediaInfo? compressedInfo = await VideoCompress.compressVideo(
          videoPath,
          quality: VideoQuality.Res1920x1080Quality,
          deleteOrigin: true,
        );

        if((compressedInfo != null) && (compressedInfo.file != null)){
          await VideoCompress.deleteAllCache();
          return compressedInfo.file!.path;
        }
      } else {
        clearPrint('Video is already within desired resolution');
        return videoPath;
      }
      return null;
    } catch (e) {
      clearPrint('Error compressing video: $e');
      return null;
    }
  }

  String getFileSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enjoy the Feed", style: Theme.of(context).textTheme.titleMedium,),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: _isLoadingNotifier,
        builder: (context, isLoading, child) {
          return isLoading ? 
          const Center(child: CircularProgressIndicator(color: Colors.purple,)) 
          : // else 
          FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: _fetchFile.getAllContent(),
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Center(
                  child: CircularProgressIndicator(color: Colors.purple, strokeWidth: 1.5,)
                );
              }else if(snapshot.hasData){
                return PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index){
                    return ShowVideo(
                      username: snapshot.data!.docs[index]['username'],
                      createdAt: snapshot.data!.docs[index]['createdAt'].toString(),
                      url: snapshot.data!.docs[index]['url'],
                      index: index,
                    );
                  }
                );
              }else{
                return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 12,),
          
                      Expanded(
                        child: Text("${snapshot.error}", style: Theme.of(context).textTheme.titleSmall,)
                      ),
                    ],
                  )
                );
              }
            }
          );
        }
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