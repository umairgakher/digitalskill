// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart'; // Ensure this path is correct
import 'package:firebase_auth/firebase_auth.dart';

import '../../admin/admindashboard/admin_dashboard.dart';
import '../../colors/color.dart';
import '../../loginsignup/login_controller.dart';
import '../Userdashboard/user_dashboard.dart';
import 'navigator.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? checkuser;
  @override
  void initState() {
    User? user = FirebaseAuth.instance.currentUser;
    super.initState();
    _checkUserLogin();
    fetchUserData(user?.uid ?? '');
  }

  Future<Map<String, dynamic>?> fetchUserData(String uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        checkuser = userDoc['checkuser'];
        loginController().checkuser = userDoc['checkuser'];
        return userDoc.data() as Map<String, dynamic>?;
      }
    }
    return null;
  }

  void _checkUserLogin() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Delay navigation to show the splash screen for at least 4 seconds
    await Future.delayed(Duration(seconds: 4));

    if (user != null) {
      // User is logged in, navigate based on role
      if (checkuser == "admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UserDashboard()),
        );
      }
    } else {
      // User is not logged in, navigate to WelcomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the width and height of the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding:
                    EdgeInsets.all(8.0), // Optional padding around the image
                child: Image.asset("assets/images/splachpic.png"),
              ),
              SizedBox(
                  height: screenHeight * 0.01), // Space between image and text
              TypewriterAnimatedTextKit(
                text: ['Skill Go Pro'],
                textStyle: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: Duration(milliseconds: 200),
                totalRepeatCount: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
