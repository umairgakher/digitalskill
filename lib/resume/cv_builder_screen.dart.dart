

// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import '../colors/color.dart';
import '../widget/appbar.dart';
import 'models/cv_data.dart';
import 'preview.dart';
import 'section/certifications_section.dart';
import 'section/education_section.dart';
import 'section/language_section.dart';
import 'section/personal_information_section.dart';
import 'section/skills_section.dart';
import 'section/work_experience_section.dart';

class CVBuilderScreen extends StatefulWidget {
  @override
  _CVBuilderScreenState createState() => _CVBuilderScreenState();
}

class _CVBuilderScreenState extends State<CVBuilderScreen> {
  int _currentSectionIndex = 0;

  // Initial CVData object that will hold all form data
  CVData cvData = CVData(
    firstName: '',
    lastName: '',
    profileImageUrl: '',
    aboutMe: '',
    dob: '',
    gender: '',
    nationality: '',
    email: '',
    phone: '',
    linkedin: '',
    portfolio: '',
    instantMessaging: '',
    website: '',
    address: '',
    postalCode: '',
    country: '',
    workExperiences: [],
    educations: [],
    skills: [],
    certifications: [],
    languages: [],
  );

  late final List<Widget> _sections;

  @override
  void initState() {
    super.initState();
    // Pass the cvData to each section where necessary
    _sections = [
      PersonalInformationSection(),
      WorkExperienceSection(),
      EducationSection(),
      SkillsSection(),
      CertificationSection(),
      LanguageSkillSection(),
    ];
  }

  void _nextSection() {
    if (_currentSectionIndex < _sections.length - 1) {
      setState(() {
        _currentSectionIndex++;
      });
    }
  }

  void _previousSection() {
    if (_currentSectionIndex > 0) {
      setState(() {
        _currentSectionIndex--;
      });
    }
  }

  Future<void> _submitCV() async {
    // Navigate to the ResumeScreen, passing the filled cvData object
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResumeScreen(), // Pass cvData to ResumeScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Create CV',
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sections[_currentSectionIndex],
              SizedBox(height: screenHeight * 0.02), // Responsive spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentSectionIndex > 0)
                    ElevatedButton(
                      onPressed: _previousSection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.backgroundColor, // Background color
                      ),
                      child: const Text(
                        'Previous',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  if (_currentSectionIndex < _sections.length - 1)
                    ElevatedButton(
                      onPressed: _nextSection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.backgroundColor, // Background color
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: _submitCV,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.backgroundColor, // Background color
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
