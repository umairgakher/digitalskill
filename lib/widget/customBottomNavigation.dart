// ignore_for_file: file_names, prefer_const_constructors, use_super_parameters

import 'package:flutter/material.dart';

import '../profile/profile.dart';
import '../user/Userdashboard/coursesSecreen.dart';
import '../user/Userdashboard/home.dart';
import '../user/Userdashboard/interview.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
        children: [
          HomeScreen(), // Page for index 0
          InterviewScreen(), // Page for index 1
          CoursesScreen(), // Page for index 2
          ProfileScreen(), // Page for index 3
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
        items: [
          _buildBottomNavigationBarItem(Icons.home, 0),
          _buildBottomNavigationBarItem(Icons.access_time, 1),
          _buildBottomNavigationBarItem(Icons.favorite, 2),
          _buildBottomNavigationBarItem(Icons.person, 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: widget.currentIndex == index ? Colors.blue : Colors.grey),
          if (widget.currentIndex == index)
            Container(
              margin: EdgeInsets.only(top: 4),
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      label: '',
    );
  }
}
