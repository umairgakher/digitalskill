// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api, avoid_print, prefer_const_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../colors/color.dart'; // Ensure you have this file for AppColors or replace it with your colors.
import '../../widget/appbar.dart';
import '../Userdashboard/coursesSecreen.dart'; // Ensure you have this file for CustomAppBar or replace it with your app bar.

class UpdateCourseScreen extends StatefulWidget {
  final String courseId;
  final Map<String, dynamic> course;

  const UpdateCourseScreen({
    required this.courseId,
    required this.course,
  });

  @override
  _UpdateCourseScreenState createState() => _UpdateCourseScreenState();
}

class _UpdateCourseScreenState extends State<UpdateCourseScreen> {
  late TextEditingController _urlController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  File? _selectedRoadmapImage;
  File? _selectedLogoImage;
  final ImagePicker _picker = ImagePicker();
  String? _selectedType;

  final List<String> _courseTypes = ['Front-End', 'Back-End', 'Other'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Initialize controllers with existing course data
    _urlController = TextEditingController(text: widget.course['url']);
    _nameController = TextEditingController(text: widget.course['name']);
    _descriptionController =
        TextEditingController(text: widget.course['description']);
    _selectedType = widget.course['type'];
  }

  @override
  Widget build(BuildContext context) {
    // Media Query for responsive design
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Update Course',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField(
              controller: _nameController,
              label: 'Course Name',
              hint: 'Enter course name',
              width: width,
              height: height,
            ),
            _buildInputField(
              controller: _urlController,
              label: 'Course URL',
              hint: 'Enter course URL',
              width: width,
              height: height,
            ),
            _buildInputField(
              controller: _descriptionController,
              label: 'Course Description',
              hint: 'Enter course description',
              maxLines: 5,
              width: width,
              height: height,
            ),
            _buildDropdownField(width, height),
            _buildImagePickerField(
              label: 'Roadmap Image',
              imageFile: _selectedRoadmapImage,
              onImagePicked: (File? image) {
                setState(() {
                  _selectedRoadmapImage = image;
                });
              },
              width: width,
              height: height,
              defaultImageUrl: widget.course['roadmap_image'],
            ),
            _buildImagePickerField(
              label: 'Logo Image',
              imageFile: _selectedLogoImage,
              onImagePicked: (File? image) {
                setState(() {
                  _selectedLogoImage = image;
                });
              },
              width: width,
              height: height,
              defaultImageUrl: widget.course['logo_image'],
            ),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                child: Text(
                  'Update',
                  style:
                      TextStyle(fontSize: width * 0.045, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height * 0.015),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.04),
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
    required String label,
    String? hint,
    int maxLines = 1,
    required double width,
    required double height,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: DropdownButtonFormField<String>(
        value: _selectedType, // This will reflect the current selected type
        decoration: InputDecoration(
          labelText: 'Course Type',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
          ),
        ),
        items: _courseTypes.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type, style: TextStyle(fontSize: width * 0.04)),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedType = value; // Update the selected type
          });
        },
      ),
    );
  }

  Widget _buildImagePickerField({
    required String label,
    required File? imageFile,
    required void Function(File?) onImagePicked,
    required double width,
    required double height,
    required String? defaultImageUrl,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: width * 0.04)),
          SizedBox(height: height * 0.01),
          GestureDetector(
            onTap: () async {
              final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                onImagePicked(File(pickedFile.path));
              }
            },
            child: Container(
              height: height * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(width * 0.03),
              ),
              child: imageFile != null
                  ? Image.file(imageFile, fit: BoxFit.cover)
                  : defaultImageUrl != null
                      ? Image.network(defaultImageUrl, fit: BoxFit.cover)
                      : Center(child: Text('Tap to select image')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    final name = _nameController.text.trim();
    final url = _urlController.text.trim();
    final description = _descriptionController.text.trim();

    // Validate input fields
    if (name.isEmpty ||
        url.isEmpty ||
        description.isEmpty ||
        _selectedType == null) {
      _showSnackbar('Please fill all fields and select a course type.');
      return;
    }

    try {
      // Update images if selected
      String roadmapImageUrl = widget.course['roadmap_image'] ?? '';
      String logoImageUrl = widget.course['logo_image'] ?? '';

      // Upload roadmap image if selected
      if (_selectedRoadmapImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('roadmap_images/${widget.courseId}.jpg');
        await ref.putFile(_selectedRoadmapImage!);
        roadmapImageUrl = await ref.getDownloadURL();
      }

      // Upload logo image if selected
      if (_selectedLogoImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('logo_images/${widget.courseId}.jpg');
        await ref.putFile(_selectedLogoImage!);
        logoImageUrl = await ref.getDownloadURL();
      }

      // Update the course document
      await FirebaseFirestore.instance
          .collection('courses')
          .doc(widget.courseId)
          .update({
        'name': name,
        'url': url,
        'description': description,
        'type': _selectedType,
        'roadmap_image': roadmapImageUrl,
        'logo_image': logoImageUrl,
      });

      // Navigate to the CoursesScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => CoursesScreen(),
        ),
      );

      _showSnackbar('Course updated successfully!');
    } catch (e) {
      print(e); // Optionally log the error
      _showSnackbar('Failed to update course. Please try again.');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
