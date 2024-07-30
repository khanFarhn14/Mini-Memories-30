import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';

class FetchFile{
  final database = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllContent() async{
    try{
      final content = await database.collection('videos').get();
      clearPrint("Fetch all content: ${content.docs[0]['username']}");
      clearPrint("Length of the fetched content: ${content.docs.length}");
      return content;
    }catch(exception){
      rethrow;
    }
  }
}