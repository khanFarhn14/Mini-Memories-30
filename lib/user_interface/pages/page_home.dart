import 'package:flutter/material.dart';
import 'package:mini_memories_30/user_interface/routes/route_name.dart';

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("This is Feed Page"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, RouteName.recordVideo);
        },
        child: const Icon(
          Icons.video_camera_back_outlined
        ),
      ),
    );
  }
}