import 'package:flutter/material.dart';

class PagePreviewVideo extends StatefulWidget {
  final String filePath;
  const PagePreviewVideo({super.key, required this.filePath});

  @override
  State<PagePreviewVideo> createState() => _PagePreviewVideoState();
}

class _PagePreviewVideoState extends State<PagePreviewVideo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Page Preview Video"),
      ),
    );
  }
}