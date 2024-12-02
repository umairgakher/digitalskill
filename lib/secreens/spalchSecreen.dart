// ignore_for_file: deprecated_member_use, prefer_const_constructors, library_private_types_in_public_api, use_key_in_widget_constructors, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable, avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../admin/admindashboard/admin_dashboard.dart';
import '../colors/color.dart';
import '../loginsignup/login_controller.dart';
import '../user/Userdashboard/user_dashboard.dart';
import 'navigator.dart'; // Ensure WelcomeScreen is defined here or import it appropriately

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? checkuser;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  /// Initializes the splash screen by fetching user data and navigating accordingly.
  Future<void> _initialize() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await fetchUserData(user.uid);
    }

    // Ensure the splash screen is displayed for at least 4 seconds
    await Future.delayed(Duration(seconds: 4));

    _navigateBasedOnUser();
  }

  /// Fetches user data from Firestore and sets the user role.
  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          checkuser = userDoc['checkuser'];
        });
        // Assuming loginController is correctly implemented elsewhere
        loginController().checkuser = userDoc['checkuser'];
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Optionally, you can handle the error by showing a message to the user
    }
  }

  /// Navigates to the appropriate dashboard based on the user's role.
  void _navigateBasedOnUser() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the width and height of the screen for responsive design
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
                child: Image.asset(
                  "assets/images/splachpic.png", // Ensure this path is correct
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                  height: screenHeight * 0.02), // Space between image and text
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
