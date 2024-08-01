import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class FetchFile{
  final database = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getAllContent() async{
    try{
      final collection = await database.collection('videos').get();
      
      // if the collection is empty then throw exception
      if(collection.docs.isEmpty){
        throw Exception('No feed to display');
      }

      return collection;
    }on SocketException{
      throw const SocketException('An error occurred while fetching');
    }catch(exception){
      rethrow;
    }
  }
}