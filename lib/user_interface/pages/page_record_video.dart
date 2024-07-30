import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mini_memories_30/user_interface/pages/page_preview_video.dart';

class PageRecordVideo extends StatefulWidget {
  const PageRecordVideo({super.key});

  @override
  State<PageRecordVideo> createState() => _PageRecordVideoState();
}

class _PageRecordVideoState extends State<PageRecordVideo> {
  late CameraController _cameraController;
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isRecordingNotifier = ValueNotifier<bool>(false);
  
  final ValueNotifier<int> _countNotifier = ValueNotifier<int>(15);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  _initCamera() async {
    try{
      //Request all available cameras from the camera plugin.
      final cameras = await availableCameras();
      final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.back);
      _cameraController = CameraController(front, ResolutionPreset.medium);
      await _cameraController.initialize();

      // After the initialization, set the _isLoading state to false.
      _isLoadingNotifier.value = false;
    }catch(exception){
      debugPrint("Exception caught is $exception");
    }
  }

  _recordVideo() async {
    
    try{
      if (_isRecordingNotifier.value) {
        final file = await _cameraController.stopVideoRecording();
        _isRecordingNotifier.value = false;
        final route = MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => PagePreviewVideo(filePath: file.path),
        );
        // ignore: use_build_context_synchronously
        Navigator.push(context, route);
      } else {
        startTimer();
        scheduleTimeout(15 * 1000);
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        _isRecordingNotifier.value = true;
      }
    }catch(exception){
      clearPrint("Exception caught in _recordVideo: $exception");
    }
  }

  startTimer(){
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if(_countNotifier.value == 0){
          timer.cancel();
        }else{
          _countNotifier.value--;
        }
      },
    );
  }

  Timer scheduleTimeout([int milliseconds = 10000])
  {
    return Timer(Duration(milliseconds: milliseconds), handleTimeout);
  }

  void handleTimeout() async { 
    final file = await _cameraController.stopVideoRecording();
    _isRecordingNotifier.value = false;
    final route = MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => PagePreviewVideo(filePath: file.path),
    );
    // ignore: use_build_context_synchronously
    Navigator.push(context, route);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
        valueListenable: _isLoadingNotifier,
        builder: (context, isLoading, child) {
          return isLoading ? const CircularProgressIndicator(color: Colors.white,):
          Center(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CameraPreview(_cameraController),
              
                ValueListenableBuilder(
                  valueListenable: _isRecordingNotifier,
                  builder: (context, isRecording, child) {
                    return Padding(
                      padding: const EdgeInsets.all(25),
                      child: FloatingActionButton(
                        backgroundColor: Colors.red,
                        // child: Icon(_isRecording ? Icons.stop : Icons.circle),
                        child: isRecording ? 
                        ValueListenableBuilder(
                          valueListenable: _countNotifier,
                          builder: (context, count, child) {
                            return Text(
                              "$count",
                              style: Theme.of(context).textTheme.bodyMedium
                            );
                          }
                        ) : const Icon(Icons.circle),
                        onPressed: () => _recordVideo(),
                      ),
                    );
                  }
                ),
              ],
            )
          );
        }
      )
    );
  }
}

// Used this for debugging
clearPrint(String message) => debugPrint(
    "-------------------------------- $message --------------------------------");