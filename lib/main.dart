import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:skiome_admin_web_portal/authentication/login_screen.dart';
import 'package:skiome_admin_web_portal/homeScreen/home_screen.dart';

Future<void> main() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBfFiBx668TjqDOF1Ljo566u1dZKeVeERU",
          appId: "1:482303533623:web:dfbb9f0aacfd0dd0ce15b2",
          messagingSenderId: "482303533623",
          projectId: "skiome"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Web Portal',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}
