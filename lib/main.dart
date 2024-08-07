import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hiking/screens/hiking_screen.dart';
import 'package:hiking/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hiking App',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: const HikingScreen(),
    );
  }
}

