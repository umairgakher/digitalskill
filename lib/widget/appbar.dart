// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors, library_private_types_in_public_api

// import 'package:digitalskill/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colors/color.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  CustomAppBar({required this.title});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? userEmail;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
      isAdmin = userEmail == 'admin@gmail.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          widget.title, // Use the title from the widget
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () =>
            Navigator.pop(context), // Navigates back to the previous screen
      ),
      // actions: isAdmin
      //     ? null
      //     : [
      //         IconButton(
      //           icon: Container(
      //             width: 50,
      //             alignment: Alignment.topLeft,
      //             child: Container(
      //               decoration: BoxDecoration(
      //                 shape: BoxShape.circle,
      //               ),
      //               child: CircleAvatar(
      //                 radius: 20, // Adjusted radius to fit better
      //                 backgroundColor: Colors.white,
      //                 child: Icon(
      //                   Icons.person,
      //                   size: 20,
      //                   color: Colors.black,
      //                 ),
      //               ),
      //             ),
      //           ),
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => ProfileScreen()),
      //             );
      //           },
      //         )
      //       ],
    );
  }
}
