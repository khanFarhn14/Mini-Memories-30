import 'package:flutter/material.dart';
import 'package:mini_memories_30/user_interface/pages/page_home.dart';
import 'package:mini_memories_30/user_interface/pages/page_username.dart';
import 'package:mini_memories_30/user_interface/pages/routes/route_name.dart';

class Routes{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      // ---------- Page Username ----------
      case RouteName.username:
        return MaterialPageRoute(builder: (context) => const PageUsername());
        
      case RouteName.home:
        return MaterialPageRoute(builder: (context) => const PageHome());

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