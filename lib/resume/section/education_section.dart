// ignore_for_file: prefer_const_constructors, avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../colors/color.dart';
import '../models/education.dart';

class EducationSection extends StatefulWidget {
  @override
  _EducationSectionState createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  final List<Education> _educations = [];
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchEducationRecords();
  }

  @override
  void dispose() {
    _degreeController.dispose();
    _institutionController.dispose();
    _locationController.dispose();
    _graduationYearController.dispose();
    super.dispose();
  }

  Future<void> _fetchEducationRecords() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user_resume').doc(userId).get();
      if (userDoc.exists) {
        List<dynamic> educationList = userDoc['educations'] ?? [];
        setState(() {
          _educations.clear();
          for (var edu in educationList) {
            _educations.add(Education(
              degree: edu['degree'] ?? '',
              institution: edu['institution'] ?? '',
              location: edu['location'] ?? '',
              graduationYear: edu['graduation_year'] ?? '',
            ));
          }
        });
      }
    } catch (e) {
      print('Error fetching education records: $e');
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      controller.text = '${pickedDate.year}'; // Only show the year
    }
  }

  void _addOrUpdateEducation() {
    if (_degreeController.text.isNotEmpty &&
        _institutionController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          // Update the existing education entry
          _educations[_editingIndex!] = Education(
            degree: _degreeController.text,
            institution: _institutionController.text,
            location: _locationController.text,
            graduationYear: _graduationYearController.text,
          );
          _editingIndex = null; // Reset editing index
        } else {
          // Add a new education entry
          _educations.add(Education(
            degree: _degreeController.text,
            institution: _institutionController.text,
            location: _locationController.text,
            graduationYear: _graduationYearController.text,
          ));
        }
        _clearFields();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill in at least degree and institution')),
      );
    }
  }

  void _removeEducation(int index) {
    setState(() {
      _educations.removeAt(index);
    });
  }

  void _editEducation(int index) {
    setState(() {
      _editingIndex = index;
      Education education = _educations[index];
      _degreeController.text = education.degree;
      _institutionController.text = education.institution;
      _locationController.text = education.location;
      _graduationYearController.text = education.graduationYear;
    });
  }

  void _clearFields() {
    _degreeController.clear();
    _institutionController.clear();
    _locationController.clear();
    _graduationYearController.clear();
    _editingIndex = null; // Clear editing index
  }

  Future<void> _saveEducation() async {
    String userId =
        FirebaseAuth.instance.currentUser!.uid; // Get the current user's ID

    // Create a list of maps from the `_educations` list
    List<Map<String, dynamic>> educationData = _educations.map((edu) {
      return {
        'degree': edu.degree ?? "",
        'institution': edu.institution ?? "",
        'location': edu.location ?? "",
        'graduation_year': edu.graduationYear ?? "",
      };
    }).toList();

    try {
      // Update the entire 'educations' field with the new data (replace existing data)
      await _firestore.collection('user_resume').doc(userId).update({
        'educations':
            educationData, // This will replace the existing list with the new one
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Education details saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save education details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final padding = screenWidth * 0.04; // Adjusts padding based on screen width

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: TextStyle(
              fontSize: screenWidth * 0.05, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // Responsive spacing
          _buildTextField(_degreeController, 'Degree', screenWidth),
          SizedBox(height: screenHeight * 0.02),
          _buildTextField(_institutionController, 'Institution', screenWidth),
          SizedBox(height: screenHeight * 0.02),
          _buildTextField(_locationController, 'Location', screenWidth),
          SizedBox(height: screenHeight * 0.02),
          _buildTextField(
              _graduationYearController, 'Graduation Year', screenWidth,
              onTap: () => _selectDate(context, _graduationYearController)),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _addOrUpdateEducation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundColor,
                ),
                child: Text(
                  _editingIndex != null ? 'Update Education' : 'Add Education',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth * 0.04, // Responsive button font size
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              if (_editingIndex == null)
                ElevatedButton(
                  onPressed: _saveEducation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            'Added Education:',
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.bold,
            ),
          ),
          ..._educations.asMap().entries.map((entry) {
            int index = entry.key;
            Education education = entry.value;
            return Card(
              margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.01), // Responsive margin
              child: ListTile(
                title: Text(
                  '${education.degree} from ${education.institution}',
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                subtitle: Text(
                  '${education.graduationYear}\n${education.location}',
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editEducation(index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeEducation(index),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, double screenWidth,
      {Function()? onTap, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
          vertical: screenWidth * 0.035,
          horizontal: screenWidth * 0.04,
        ),
      ),
      maxLines: maxLines,
      onTap: onTap,
    );
  }
}
