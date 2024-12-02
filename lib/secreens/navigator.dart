// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_import, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
import '../colors/color.dart';
import '../loginsignup/login.dart';
import '../loginsignup/signup.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenHeight * 0.1,
                ),
                Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: screenHeight * 0.04,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Skills Go Pro',
                  style: TextStyle(
                    fontSize: screenHeight * 0.06,
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'A place where you can Updgarde your soft skills.',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: screenHeight * 0.025,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      "Sign up",
                      style:
                          TextStyle(fontSize: 20, color: AppColors.buttontext),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                    ),
                    child: Text(
                      "Login",
                      style:
                          TextStyle(fontSize: 20, color: AppColors.buttontext),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
