// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../colors/color.dart';
import '../../feadback/feedback.dart';
import '../../loginsignup/login.dart';
import '../../profile/profile.dart';
import '../../user/Userdashboard/coursesSecreen.dart';
import '../../user/Userdashboard/interview.dart';
import '../../user/resume/resumelistingadmin.dart';

class AdminDashboard extends StatefulWidget {
  AdminDashboard({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String? _userName;
  String? _userEmail;
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _userName = userDoc['username']; // Assuming 'username' field exists
        _userEmail = userDoc['email']; // Assuming 'email' field exists
        _profileImageUrl = userDoc[
            'profileImage']; // Assuming 'profile_image_url' field exists
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Admin Dashboard",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenHeight * 0.03,
            ),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            widget._scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header
            UserAccountsDrawerHeader(
              accountName: Text(_userName ?? "User Name"),
              accountEmail: Text(_userEmail ?? "user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: _profileImageUrl == null
                    ? Icon(Icons.person,
                        color: AppColors.backgroundColor, size: 50)
                    : null,
              ),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.home,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      "Home",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminDashboard()),
                    ), // Home
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.access_time,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      "Interview",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InterviewScreen()),
                      );
                    }, // Interview
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.note,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      "Feadback",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    onTap: () {
                      // Implement logout functionality here FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => FeedbackScreen()),
                        (Route<dynamic> route) => false,
                      );
                      // Navigate to login screen or show a confirmation dialog
                    },
                  ),
                  Divider(),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.document_scanner,
                  //     color: AppColors.backgroundColor,
                  //   ),
                  //   title: Text(
                  //     "Resume",
                  //     style: TextStyle(fontSize: screenHeight * 0.025),
                  //   ),
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => ResumeListScreen()),
                  //     );
                  //   }, // Resume
                  // ),
                  // Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      "Courses",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CoursesScreen()),
                      );
                    }, // Courses
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      "Profile",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      );
                    }, // Profile
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDashboardItem(
                title: 'Courses',
                height: screenHeight * 0.25, // 25% of screen height
                backgroundColor: AppColors.backgroundColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CoursesScreen()),
                  );
                },
                screenHeight: screenHeight,
              ),
              // SizedBox(height: screenHeight * 0.04), // Spacing between items
              // _buildDashboardItem(
              //   title: 'CV/Resume',
              //   height: screenHeight * 0.25, // 25% of screen height
              //   backgroundColor: AppColors.backgroundColor,
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => ResumeListScreen()),
              //     );
              //   },
              //   screenHeight: screenHeight,
              // ),
              SizedBox(height: screenHeight * 0.04), // Spacing between items
              _buildDashboardItem(
                title: 'Interviews',
                height: screenHeight * 0.25, // 25% of screen height
                backgroundColor: AppColors.backgroundColor,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InterviewScreen()),
                  );
                },
                screenHeight: screenHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem({
    required String title,
    required double height,
    required Color backgroundColor,
    required VoidCallback onTap,
    required double screenHeight,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: screenHeight * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Ensure text is visible on the background
            ),
          ),
        ),
      ),
    );
  }
}
