import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';

class UploadFile {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadVideo({required String videoTitle, required String videoPath}) async {
    final File file = File(videoPath);
    
    // Check if file exists
    if (!await file.exists()) {
      clearPrint("File does not exist at path: $videoPath");
      throw Exception("Video file not found");
    }

    // Create a reference to the location you want to upload to in Firebase Storage
    final Reference ref = _storage.ref().child('memories/$videoTitle.mp4');

    try {
      // Upload the file
      clearPrint("Starting upload for file: $videoPath");
      final UploadTask uploadTask = ref.putFile(file);

      // Wait until the file is uploaded
      await uploadTask;

      // Get the download URL
      final String downloadURL = await ref.getDownloadURL();
      clearPrint("Upload successful. Download URL: $downloadURL");
    } on FirebaseException catch (e) {
      clearPrint("Firebase Exception: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      clearPrint("Unexpected error during upload: $e");
      rethrow;
    }
  }
}