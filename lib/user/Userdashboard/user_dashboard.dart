// ignore_for_file: unused_field, unused_local_variable, unused_element, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../colors/color.dart';
import '../../feadback/feedback.dart';
import '../../loginsignup/login.dart';
import '../../profile/profile.dart';
import 'coursesSecreen.dart';
import 'home.dart';
import 'interview.dart';

class UserDashboard extends StatefulWidget {
  UserDashboard({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openEndDrawer() {
    _scaffoldKey.currentState!.openEndDrawer();
  }

  void _closeEndDrawer(context) {
    Navigator.of(context).pop();
  }

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  String? text = "Home";
  double _appBarHeight = 60;
  User? _user;
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
        _user = user;
        _userName = userDoc['username']; // Assuming 'username' field exists
        _userEmail = userDoc['email']; // Assuming 'email' field exists
        _profileImageUrl = userDoc[
            'profileImage']; // Assuming 'profile_image_url' field exists
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        text = "Home";
      }
      if (index == 1) {
        text = "Interview";
      }
      if (index == 2) {
        text = "Courses";
      }
      if (index == 3) {
        text = "Profile";
      }
    });
  }

  void _onDrawerItemTapped(int index) {
    Navigator.of(context).pop(); // Close the drawer
    _onItemTapped(index); // Update the selected index and text
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    _appBarHeight = screenHeight * 0.07;

    return Scaffold(
      key: widget._scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: Text(
            text!,
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
                    onTap: () => _onDrawerItemTapped(0), // Home
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
                    onTap: () => _onDrawerItemTapped(1), // Interview
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(
                      Icons.favorite,
                      color: AppColors.backgroundColor,
                    ),
                    title: Text(
                      "Courses",
                      style: TextStyle(fontSize: screenHeight * 0.025),
                    ),
                    onTap: () => _onDrawerItemTapped(2), // Courses
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
                    onTap: () => _onDrawerItemTapped(3), // Profile
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
                      // Implement logout functionality here FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                      // Navigate to login screen or show a confirmation dialog
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _onItemTapped,
        items: [
          _buildBottomNavigationBarItem(Icons.home, 0),
          _buildBottomNavigationBarItem(Icons.access_time, 1),
          _buildBottomNavigationBarItem(Icons.favorite, 2),
          _buildBottomNavigationBarItem(Icons.person, 3),
        ],
      ),
      body: Container(
        child: _getPage(_selectedIndex),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(icon),
          if (_selectedIndex == index)
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      label: '',
    );
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        text = "Courses";
        return HomeScreen();
      case 1:
        text = "Interview";
        return InterviewScreen();
      case 2:
        text = "Courses";
        return CoursesScreen();
      case 3:
        text = "Profile";
        return ProfileScreen();
      default:
        return Container();
    }
  }
}
