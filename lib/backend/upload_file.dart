import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mini_memories_30/user_interface/pages/page_upload_video.dart';

class UploadFile {
  BuildContext context;
  UploadFile({required this.context});

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadVideo({required String username,required String videoTitle, required String videoPath, required int duration}) async {
    final File file = File(videoPath);
    
    // Check if file exists
    if (!await file.exists()) {
      throw Exception("Video file not found");
    }
    

    try {
      final Reference ref = _storage.ref().child('memories/$videoTitle.mp4');
      final UploadTask uploadTask = ref.putFile(file);

      await uploadTask;

      // Get the download URL
      final String downloadURL = await ref.getDownloadURL();
      await _saveVideoMetadata(downloadURL, username, duration);

    } on FirebaseException catch (e) {
      clearPrint("Firebase Exception: ${e.code} - ${e.message}");
      rethrow;
    } catch (e) {
      clearPrint("Unexpected error during upload: $e");
      rethrow;
    }
  }

  Future<void> _saveVideoMetadata(String videoUrl, String username, int duration) async {
    try{
      clearPrint("Saving video metadata");
      await FirebaseFirestore.instance.collection('videos').add({
        'url': videoUrl,
        'username': username,
        'duration': duration, // in seconds
        'createdAt': FieldValue.serverTimestamp(),
      });
    }catch(exception){
      clearPrint("Error saving video metadata: $exception");
      rethrow;
    }
  }
}