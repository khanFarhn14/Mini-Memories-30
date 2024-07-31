import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mini_memories_30/firebase_options.dart';
import 'package:mini_memories_30/user_interface/routes/route_name.dart';
import 'package:mini_memories_30/user_interface/routes/routes.dart';
import 'package:mini_memories_30/user_interface/state-management/upload_progress.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UploadProgress()),
      ],
      child: MaterialApp(
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        initialRoute: RouteName.home,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}