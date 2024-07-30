import 'package:flutter/material.dart';

class UploadProgress extends ChangeNotifier{
  double progress = 0.0;

  void updateProgress(double updatedProgress){
    progress = updatedProgress;
    notifyListeners();
  }
}