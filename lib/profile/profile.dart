// ignore_for_file: use_key_in_widget_constructors, use_build_context_synchronously, use_build_context_synchronously, use_build_context_synchronously, duplicate_ignore, library_private_types_in_public_api, deprecated_member_use, prefer_const_constructors, sort_child_properties_last, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import '../colors/color.dart';
import '../loginsignup/login.dart';
import '../loginsignup/login_controller.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  String? profileImage;
  String name = "";
  String phone = "";
  String email = "";
  String about = "";

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        setState(() {
          name = userData['username'] ?? '';
          phone = userData['uPhone'] ?? '';
          email = userData['email'] ?? '';
          profileImage = userData['profileImage'] ?? '';
          about = userData['aboutme'] ?? '';
        });
      }
    } catch (e) {
      // Handle error if fetching user data fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final textScaleFactor = mediaQuery.textScaleFactor;

    return Scaffold(
      appBar: loginController().checkuser == "admin"
          ? AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Center(
                child: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              backgroundColor: AppColors.backgroundColor,
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileAvatar(screenWidth),
              SizedBox(height: screenHeight * 0.03),
              _buildProfileInfo("Name", name, () {
                _showEditDialog(context, "Name", name, (newValue) {
                  _updateUserProfile('username', newValue);
                });
              }, textScaleFactor),
              _buildProfileInfo("Phone", phone, () {
                _showEditDialog(context, "Phone", phone, (newValue) {
                  _updateUserProfile('uPhone', newValue);
                });
              }, textScaleFactor),
              _buildProfileInfo("Email", email, () {}, textScaleFactor),
              _buildProfileInfo("Tell Us About Yourself", about, () {
                _showEditDialog(context, "About", about, (newValue) {
                  _updateUserProfile('aboutme', newValue);
                });
              }, textScaleFactor),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: ElevatedButton(
                  onPressed: _logOut,
                  child: Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                    minimumSize: Size(screenWidth * 0.5, screenHeight * 0.07),
                    textStyle: TextStyle(fontSize: textScaleFactor * 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(double screenWidth) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: screenWidth * 0.4,
            height: screenWidth * 0.4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.backgroundColor, width: 6.0),
            ),
            child: CircleAvatar(
              radius: screenWidth * 0.25,
              backgroundColor:
                  Colors.grey[200], // Optional: Add a background color
              child: profileImage != null && profileImage!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        profileImage!,
                        fit: BoxFit.cover,
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: AppColors.backgroundColor,
                      size: screenWidth * 0.25,
                    ),
            ),
          ),
          Positioned(
            bottom: -9,
            right: -10,
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _pickImage,
                iconSize: screenWidth * 0.08,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(
      String title, String value, VoidCallback onEdit, double textScaleFactor) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.backgroundColor,
                    fontSize: textScaleFactor * 18,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Text(
                  value,
                  overflow: TextOverflow.visible,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: textScaleFactor * 16,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          if (title != "Email")
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String field, String currentValue,
      ValueChanged<String> onSave) {
    TextEditingController _controller =
        TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit $field"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: field),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                String newValue = _controller.text.trim();

                // Perform validation
                if (field == 'Name' &&
                    (newValue.isEmpty || newValue.length < 3)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Name must be at least 3 characters long')),
                  );
                } else if (field == 'Phone' &&
                    (newValue.isEmpty || newValue.length != 10)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Phone number must be exactly 10 digits long')),
                  );
                } else {
                  onSave(newValue);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserProfile(String field, String newValue) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({field: newValue});

        // Updating local state after successful update
        setState(() {
          if (field == 'username') {
            name = newValue;
          } else if (field == 'uPhone') {
            phone = newValue;
          } else if (field == 'aboutme') {
            about = newValue;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$field updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update $field: $e')),
        );
      }
    }
  }

  void _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        // Upload image to Firebase Storage
        File imageFile = File(pickedFile.path);
        String fileName =
            'profile_images/${FirebaseAuth.instance.currentUser!.uid}.jpg';
        Reference storageReference =
            FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageReference.putFile(imageFile);
        TaskSnapshot storageTaskSnapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

        // Update profile image URL in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({'profileImage': downloadUrl});

        setState(() {
          profileImage = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile image: $e')),
        );
      }
    }
  }

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }
}
