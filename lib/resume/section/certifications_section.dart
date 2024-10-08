// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_to_list_in_spreads

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../colors/color.dart';
import '../models/certification.dart';

class CertificationSection extends StatefulWidget {
  @override
  _CertificationSectionState createState() => _CertificationSectionState();
}

class _CertificationSectionState extends State<CertificationSection> {
  final List<Certification> _certifications = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _dateObtainedController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int? _editingIndex;

  @override
  void initState() {
    super.initState();
    _fetchCertifications();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _organizationController.dispose();
    _dateObtainedController.dispose();
    super.dispose();
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
      controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> _fetchCertifications() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('user_resume').doc(userId).get();
      if (snapshot.exists && snapshot['certifications'] != null) {
        List certificationsData = snapshot['certifications'];
        setState(() {
          _certifications.clear();
          _certifications.addAll(certificationsData.map((cert) => Certification(
                name: cert['name'],
                issuingOrganization: cert['issuingOrganization'],
                dateObtained: cert['dateObtained'],
              )));
        });
      }
    } catch (e) {
      _showSnackBar('Failed to fetch certifications: $e');
    }
  }

  void _addOrUpdateCertification() {
    if (_nameController.text.isNotEmpty &&
        _organizationController.text.isNotEmpty &&
        _dateObtainedController.text.isNotEmpty) {
      setState(() {
        if (_editingIndex != null) {
          _certifications[_editingIndex!] = Certification(
            name: _nameController.text,
            issuingOrganization: _organizationController.text,
            dateObtained: _dateObtainedController.text,
          );
          _editingIndex = null;
        } else {
          _certifications.add(Certification(
            name: _nameController.text,
            issuingOrganization: _organizationController.text,
            dateObtained: _dateObtainedController.text,
          ));
        }
        _clearControllers();
      });
    } else {
      _showSnackBar('Please fill in all fields');
    }
  }

  void _removeCertification(int index) {
    setState(() {
      _certifications.removeAt(index);
    });
  }

  void _editCertification(int index) {
    Certification certification = _certifications[index];
    _nameController.text = certification.name;
    _organizationController.text = certification.issuingOrganization;
    _dateObtainedController.text = certification.dateObtained;
    _editingIndex = index;
  }

  void _clearControllers() {
    _nameController.clear();
    _organizationController.clear();
    _dateObtainedController.clear();
    _editingIndex = null;
  }

  Future<void> _saveCertifications() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    List<Map<String, dynamic>> certificationData = _certifications.map((cert) {
      return {
        'name': cert.name ?? "",
        'issuingOrganization': cert.issuingOrganization ?? "",
        'dateObtained': cert.dateObtained ?? "",
      };
    }).toList();
    try {
      await _firestore.collection('user_resume').doc(userId).update({
        'certifications': certificationData,
      });
      _showSnackBar('Certifications saved successfully!');
    } catch (e) {
      _showSnackBar('Failed to save certifications: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Certifications',
            style: TextStyle(
              fontSize: screenWidth * 0.05, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.02), // Responsive spacing
          _buildTextField(_nameController, 'Certification Name', screenWidth),
          SizedBox(height: screenHeight * 0.02),
          _buildTextField(
              _organizationController, 'Issuing Organization', screenWidth),
          SizedBox(height: screenHeight * 0.02),
          _buildTextField(_dateObtainedController, 'Date Obtained', screenWidth,
              onTap: () => _selectDate(context, _dateObtainedController)),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _addOrUpdateCertification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.backgroundColor,
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.02,
                    horizontal: screenWidth * 0.1,
                  ),
                ),
                child: Text(
                  _editingIndex != null
                      ? 'Update Certification'
                      : 'Add Certification',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.white, // Responsive button text size
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              if (_editingIndex == null)
                ElevatedButton(
                  onPressed: _saveCertifications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                    padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.1,
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          screenWidth * 0.04, // Responsive button text size
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            'Added Certifications:',
            style: TextStyle(
              fontSize: screenWidth * 0.045, // Responsive font size
              fontWeight: FontWeight.bold,
            ),
          ),
          ..._certifications.asMap().entries.map((entry) {
            int index = entry.key;
            Certification certification = entry.value;
            return Card(
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              child: ListTile(
                title: Text(
                  certification.name,
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
                subtitle: Text(
                  '${certification.issuingOrganization}\nObtained on: ${certification.dateObtained}',
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, size: screenWidth * 0.06),
                      onPressed: () {
                        _editCertification(index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: screenWidth * 0.06),
                      onPressed: () => _removeCertification(index),
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
          vertical: screenWidth * 0.04,
          horizontal: screenWidth * 0.04,
        ),
      ),
      maxLines: maxLines,
      onTap: onTap,
    );
  }
}
