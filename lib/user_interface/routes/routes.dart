import 'package:flutter/material.dart';
import 'package:mini_memories_30/user_interface/pages/page_home.dart';
import 'package:mini_memories_30/user_interface/pages/page_username.dart';
import 'package:mini_memories_30/user_interface/routes/route_name.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      // ---------- Page Username ----------
      case RouteName.username:
        return MaterialPageRoute(builder: (context) => const PageUsername());
        
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const PageHome());

      // case RouteName.recordVideo:
      //   return PageRouteBuilder(
      //     pageBuilder: (context, animation, secondaryAnimation) => const PageRecordVideo(),
      //     transitionsBuilder: (context, animation, secondaryAnimation, child){
      //       return SlideTransition(
      //         position: Tween<Offset>(
      //           begin: const Offset(0,1),
      //           end: Offset.zero,
      //         ).animate(animation),
      //         child: child,
      //       );
      //     }
      //   );

      default: return MaterialPageRoute(
        builder: (context){
          return const Scaffold(
            body: Center(
              child: Text('No Route Defined'),
            ),
          );
        }
      );
    }
  }
}