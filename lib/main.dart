// ignore_for_file: unused_import, prefer_const_constructors
// import 'package:digitalskill/firebase_options.dart';
import 'package:flutter/material.dart';

import 'secreens/spalchSecreen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // Ensure that Flutter is initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase.
  await Firebase.initializeApp();

  // Continue with the rest of your application setup.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      // home: UserDashboard(),
      // home: AdminDashboard(),
    );
  }
}
