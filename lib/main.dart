//vpost-2
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:vpost_2/responses/mobile_screen_layout.dart';
//import 'package:vpost_2/responses/responsive_layout.dart';
//import 'package:vpost_2/responses/web_layout.dart';
import 'package:vpost_2/screens/login.dart';
//import 'package:vpost_2/screens/register.dart';
import 'package:vpost_2/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VPOST-2',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),

      home: const LoginScreen(),
    );
  }
}
