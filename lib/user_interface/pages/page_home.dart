import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_memories_30/backend/fetch_file.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';
import 'package:mini_memories_30/user_interface/widgets/components.dart';
import 'package:mini_memories_30/user_interface/widgets/show_video.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {

  final FetchFile _fetchFile = FetchFile();

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
      appBar: AppBar(
        title: Text("Enjoy the Feed", style: Theme.of(context).textTheme.titleMedium,),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
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