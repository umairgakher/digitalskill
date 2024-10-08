// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, library_private_types_in_public_api, sort_child_properties_last, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../colors/color.dart';
import '../../widget/appbar.dart';
import '../Userdashboard/coursesSecreen.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedRoadmapImage;
  File? _selectedLogoImage;
  final ImagePicker _picker = ImagePicker();
  String? _selectedType;

  final List<String> _courseTypes = ['Front-End', 'Back-End', 'Other'];
  bool _isLoading = false; // to show loading spinner during form submission

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add New Course',
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Course Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInputField(
                    controller: _nameController,
                    hintText: 'Enter course name',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Course URL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInputField(
                    controller: _urlController,
                    hintText: 'Enter course URL',
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Course Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildDropdown(),
                  SizedBox(height: 20),
                  Text(
                    'Course Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInputField(
                    controller: _descriptionController,
                    hintText: 'Enter course description',
                    maxLines: 4,
                  ),
                  SizedBox(height: 20),
                  _buildImagePicker(
                    imageType: 'Roadmap Image',
                    selectedImage: _selectedRoadmapImage,
                    onPickImage: () => _pickImage('roadmap'),
                  ),
                  SizedBox(height: 20),
                  _buildImagePicker(
                    imageType: 'Course Logo Image',
                    selectedImage: _selectedLogoImage,
                    onPickImage: () => _pickImage('logo'),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: hintText,
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      hint: Text('Select course type'),
      items: _courseTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }

  Widget _buildImagePicker({
    required String imageType,
    required File? selectedImage,
    required VoidCallback onPickImage,
  }) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(imageType, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8.0),
          selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    selectedImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.backgroundColor),
                  ),
                  child: Center(
                    child: Icon(
                      imageType == 'Roadmap Image' ? Icons.image : Icons.photo,
                      size: 50.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
          SizedBox(height: 8.0),
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(Icons.add_a_photo, size: 32.0),
              onPressed: onPickImage,
              tooltip: 'Select Image',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (imageType == 'roadmap') {
          _selectedRoadmapImage = File(pickedFile.path);
        } else if (imageType == 'logo') {
          _selectedLogoImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<void> _submitForm() async {
    final name = _nameController.text.trim();
    final url = _urlController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty ||
        url.isEmpty ||
        description.isEmpty ||
        _selectedType == null ||
        _selectedRoadmapImage == null ||
        _selectedLogoImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields and upload all images.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true; // show loading spinner
    });

    try {
      // Upload images to Firebase Storage and get the URLs
      String roadmapImageUrl = '';
      String logoImageUrl = '';

      if (_selectedRoadmapImage != null) {
        final roadmapImageRef = FirebaseStorage.instance.ref().child(
            'course_images/${DateTime.now().millisecondsSinceEpoch}_roadmap.jpg');
        await roadmapImageRef.putFile(_selectedRoadmapImage!);
        roadmapImageUrl = await roadmapImageRef.getDownloadURL();
      }

      if (_selectedLogoImage != null) {
        final logoImageRef = FirebaseStorage.instance.ref().child(
            'course_images/${DateTime.now().millisecondsSinceEpoch}_logo.jpg');
        await logoImageRef.putFile(_selectedLogoImage!);
        logoImageUrl = await logoImageRef.getDownloadURL();
      }

      // Save course data to Firestore
      await FirebaseFirestore.instance.collection('courses').add({
        'name': name,
        'url': url,
        'type': _selectedType,
        'description': description,
        'roadmap_image': roadmapImageUrl,
        'logo_image': logoImageUrl,
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course added successfully!'),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CoursesScreen()),
      );
    } catch (error) {
      print('Error saving course: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving course. Please try again.'),
        ),
      );
    }

    setState(() {
      _isLoading = false; // hide loading spinner
    });
  }
}
