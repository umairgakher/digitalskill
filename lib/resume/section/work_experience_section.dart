// ignore_for_file: library_private_types_in_public_api, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../colors/color.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/work_experience.dart';

class WorkExperienceSection extends StatefulWidget {
  @override
  _WorkExperienceSectionState createState() => _WorkExperienceSectionState();
}

class _WorkExperienceSectionState extends State<WorkExperienceSection> {
  final List<WorkExperience> _workExperiences = [];
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchWorkExperiences();
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchWorkExperiences() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user_resume').doc(userId).get();
      if (userDoc.exists) {
        List<dynamic> experiences = userDoc['work_experiences'] ?? [];
        setState(() {
          _workExperiences.clear();
          for (var exp in experiences) {
            _workExperiences.add(WorkExperience(
              jobTitle: exp['job_title'] ?? '',
              company: exp['company'] ?? '',
              location: exp['location'] ?? '',
              from: exp['from'] ?? '',
              to: exp['to'] ?? '',
              description: exp['description'] ?? '',
            ));
          }
        });
      }
    } catch (e) {
      print('Error fetching work experiences: $e');
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
      controller.text =
          '${pickedDate.toLocal()}'.split(' ')[0]; // Formatting the date
    }
  }

  void _addOrUpdateWorkExperience() {
    if (_jobTitleController.text.isNotEmpty &&
        _companyController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          // Update existing work experience
          _workExperiences[_editingIndex!] = WorkExperience(
            jobTitle: _jobTitleController.text,
            company: _companyController.text,
            location: _locationController.text,
            from: _fromController.text,
            to: _toController.text,
            description: _descriptionController.text,
          );
          _editingIndex = null; // Clear editing index after update
        } else {
          // Add new work experience
          _workExperiences.add(WorkExperience(
            jobTitle: _jobTitleController.text,
            company: _companyController.text,
            location: _locationController.text,
            from: _fromController.text,
            to: _toController.text,
            description: _descriptionController.text,
          ));
        }
        _clearFields();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Please fill in at least job title and company')),
      );
    }
  }

  void _clearFields() {
    _jobTitleController.clear();
    _companyController.clear();
    _locationController.clear();
    _fromController.clear();
    _toController.clear();
    _descriptionController.clear();
    _editingIndex = null; // Clear editing index
  }

  void _editWorkExperience(int index) {
    WorkExperience experience = _workExperiences[index];
    _jobTitleController.text = experience.jobTitle;
    _companyController.text = experience.company;
    _locationController.text = experience.location;
    _fromController.text = experience.from;
    _toController.text = experience.to;
    _descriptionController.text = experience.description;
    setState(() {
      _editingIndex = index; // Set editing index
    });
  }

  void _removeWorkExperience(int index) {
    setState(() {
      _workExperiences.removeAt(index);
    });
  }

  Future<void> _saveWorkExperience() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> workExperienceData =
        _workExperiences.map((work) {
      return {
        'job_title': work.jobTitle ?? "",
        'company': work.company ?? "",
        'location': work.location ?? "",
        'from': work.from ?? "",
        'to': work.to ?? "",
        'description': work.description ?? "",
      };
    }).toList();

    try {
      // Save the 'work_experiences' array in the user's document in 'user_resume'
      await _firestore.collection('user_resume').doc(userId).set({
        'work_experiences': workExperienceData, // Replace existing array
      }, SetOptions(merge: true)); // Use merge to keep other fields intact

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Work experience details saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save work experience details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Work Experience',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _buildTextField(_jobTitleController, 'Job Title'),
          SizedBox(height: 10),
          _buildTextField(_companyController, 'Company'),
          SizedBox(height: 10),
          _buildTextField(_locationController, 'Location'),
          SizedBox(height: 10),
          _buildTextField(_fromController, 'From',
              onTap: () => _selectDate(context, _fromController)),
          SizedBox(height: 10),
          _buildTextField(_toController, 'To',
              onTap: () => _selectDate(context, _toController)),
          SizedBox(height: 10),
          _buildTextField(_descriptionController, 'Description', maxLines: 3),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _addOrUpdateWorkExperience,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor
                    // Background color
                    // Text color
                    ),
                child: Text(
                  _editingIndex == null
                      ? 'Add Work Experience'
                      : 'Update Work Experience',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10),
              if (_editingIndex == null) // Show Save button only when adding
                ElevatedButton(
                  onPressed: _saveWorkExperience,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor
                      // Background color
                      // Text color
                      ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
          SizedBox(height: 20),
          Text('Added Work Experiences:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ..._workExperiences.asMap().entries.map((entry) {
            int index = entry.key;
            WorkExperience experience = entry.value;
            return Card(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text('${experience.jobTitle} at ${experience.company}'),
                subtitle: Text(
                    '${experience.from} - ${experience.to}\n${experience.description}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _editWorkExperience(index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeWorkExperience(index),
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

  Widget _buildTextField(TextEditingController controller, String label,
      {Function()? onTap, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      maxLines: maxLines,
      onTap: onTap,
    );
  }
}
