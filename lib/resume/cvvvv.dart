// // ignore_for_file: prefer_const_literals_to_create_immutables

// import 'dart:io';
// import 'package:digitalskill/colors/color.dart';
// import 'package:digitalskill/resume/resumetamplate.dart';
// import 'package:digitalskill/widget/appbar.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// // Define your AppColors class

// class CVBuilderScreen extends StatefulWidget {
//   @override
//   _CVBuilderScreenState createState() => _CVBuilderScreenState();
// }

// class _CVBuilderScreenState extends State<CVBuilderScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // Section Index
//   int _currentSectionIndex = 0;

//   // Personal Info Controllers
//   final _firstNameController = TextEditingController();
//   final _lastNameController = TextEditingController();
//   final _profileImageUrlController = TextEditingController();
//   final _aboutMeController = TextEditingController();
//   final _dobController = TextEditingController();
//   final _genderController = TextEditingController();
//   final _nationalityController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _linkedinController = TextEditingController();
//   final _portfolioController = TextEditingController();
//   final _instantMessagingController = TextEditingController();
//   final _websiteController = TextEditingController();
//   final _addressController = TextEditingController();
//   final _postalCodeController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _countryController = TextEditingController();

//   // Work Experience
//   final _workExperiences = <WorkExperience>[];
//   final _jobTitleController = TextEditingController();
//   final _companyController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _workFromController = TextEditingController();
//   final _workToController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   // Education
//   final _educations = <Education>[];
//   final _degreeController = TextEditingController();
//   final _institutionController = TextEditingController();
//   final _eduLocationController = TextEditingController();
//   final _graduationYearController = TextEditingController();

//   // Skills
//   final _skills = <String>[];
//   final _skillController = TextEditingController();

//   // Languages
//   final _languages = <LanguageSkill>[];
//   final _languageNameController = TextEditingController();
//   final _readingProficiencyController = TextEditingController();
//   final _writingProficiencyController = TextEditingController();
//   final _speakingProficiencyController = TextEditingController();

//   // Certifications
//   final _certifications = <Certification>[];
//   final _certificationNameController = TextEditingController();
//   final _issuingOrganizationController = TextEditingController();
//   final _certificationDateController = TextEditingController();

//   // Projects
//   final _projects = <Project>[];
//   final _projectTitleController = TextEditingController();
//   final _projectDescriptionController = TextEditingController();
//   final _technologiesUsedController = TextEditingController();
//   final _roleController = TextEditingController();

//   // Hobbies
//   final _hobbies = <Hobby>[];
//   final _hobbyNameController = TextEditingController();
//   final _hobbyDescriptionController = TextEditingController();

//   // References
//   final _references = <Reference>[];
//   final _referenceNameController = TextEditingController();
//   final _referenceRelationshipController = TextEditingController();
//   final _referenceContactController = TextEditingController();

//   File? _profileImage;
//   String? _profileImageUrl;
//   final ImagePicker _picker = ImagePicker();

// // Add this method to handle image upload
//   Future<void> _pickImage() async {
//     try {
//       // Pick an image from the gallery
//       final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         final file = File(pickedFile.path);

//         // Display the selected image locally
//         setState(() {
//           _profileImage = file;
//         });

//         // Upload the image to Firebase Storage
//         final storageRef = FirebaseStorage.instance.ref();
//         final imageRef = storageRef
//             .child('profile_images/${DateTime.now().toIso8601String()}');
//         final uploadTask = imageRef.putFile(file);

//         // Wait for the upload to complete
//         final snapshot = await uploadTask.whenComplete(() => {});
//         final downloadUrl = await snapshot.ref.getDownloadURL();

//         if (mounted) {
//           setState(() {
//             _profileImageUrl = downloadUrl; // Update the URL
//             _profileImageUrlController.text =
//                 downloadUrl; // Update the TextEditingController
//           });
//         }
//       }
//     } catch (error) {
//       print('Failed to upload image: $error');
//     }
//   }

//   void _nextSection() {
//     if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
//       // Show an error message or prevent navigation
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please enter your first name and last name.'),
//         ),
//       );
//       return;
//     } else if (_profileImageUrl == null || _profileImageUrl!.isEmpty) {
//       // Show an error message or prevent navigation
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Please select a profile image.'),
//         ),
//       );
//       return;
//     }
//     if (_currentSectionIndex < 9) {
//       setState(() {
//         _currentSectionIndex++;
//       });
//     }
//   }

//   void _previousSection() {
//     if (_currentSectionIndex > 0) {
//       setState(() {
//         _currentSectionIndex--;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: "CV Builder"),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (_currentSectionIndex == 0) _buildPersonalInformation(),
//               if (_currentSectionIndex == 1) _buildWorkExperience(),
//               if (_currentSectionIndex == 2) _buildEducation(),
//               if (_currentSectionIndex == 3) _buildSkills(),
//               if (_currentSectionIndex == 4) _buildLanguages(),
//               if (_currentSectionIndex == 5) _buildCertifications(),
//               if (_currentSectionIndex == 6) _buildProjects(),
//               if (_currentSectionIndex == 7) _buildHobbies(),
//               if (_currentSectionIndex == 8) _buildReferences(),
//               if (_currentSectionIndex == 9) _buildSaveButton(),
//               _buildSectionNavigationButtons(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildTextField(TextEditingController controller, String label) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(labelText: label),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter $label';
//         }
//         return null;
//       },
//     );
//   }

//   Widget _buildTextFieldWithDatePicker(
//       TextEditingController controller, String label) {
//     return GestureDetector(
//       onTap: () async {
//         final selectedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(1900),
//           lastDate: DateTime.now(),
//         );
//         if (selectedDate != null) {
//           setState(() {
//             controller.text = '${selectedDate.toLocal()}'.split(' ')[0];
//           });
//         }
//       },
//       child: AbsorbPointer(
//         child: _buildTextField(controller, label),
//       ),
//     );
//   }

//   Widget _buildListView<T>(List<T> items, Widget Function(T item) itemBuilder) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: itemBuilder(items[index]),
//         );
//       },
//     );
//   }

//   Widget _buildPersonalInformation() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Profile Picture'),
//         // Display profile image or prompt to select an image
//         _profileImageUrl != null && _profileImageUrl!.isNotEmpty
//             ? Image.network(
//                 _profileImageUrl!,
//                 width: double.infinity,
//                 height: 150,
//                 fit: BoxFit.cover,
//               )
//             : GestureDetector(
//                 onTap: _pickImage,
//                 child: Container(
//                   color: Colors.grey[200],
//                   width: double.infinity,
//                   height: 150,
//                   child: Center(
//                     child: Text('Tap to select image'),
//                   ),
//                 ),
//               ),
//         SizedBox(height: 16),
//         _buildSectionTitle('Personal Information'),
//         _buildTextField(_firstNameController, 'First Name'),
//         _buildTextField(_lastNameController, 'Last Name'),
//         _buildTextField(_profileImageUrlController, 'Profile Image URL'),
//         _buildTextField(_aboutMeController, 'About Me'),
//         _buildTextFieldWithDatePicker(_dobController, 'Date of Birth'),
//         _buildTextField(_genderController, 'Gender'),
//         _buildTextField(_nationalityController, 'Nationality'),
//         _buildTextField(_emailController, 'Email'),
//         _buildTextField(_phoneController, 'Phone'),
//         _buildTextField(_linkedinController, 'LinkedIn'),
//         _buildTextField(_portfolioController, 'Portfolio'),
//         _buildTextField(_instantMessagingController, 'Instant Messaging'),
//         _buildTextField(_websiteController, 'Website'),
//         _buildTextField(_addressController, 'Address'),
//         _buildTextField(_postalCodeController, 'Postal Code'),
//         _buildTextField(_cityController, 'City'),
//         _buildTextField(_countryController, 'Country'),
//       ],
//     );
//   }

//   Widget _buildWorkExperience() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Work Experience'),
//         _buildTextField(_jobTitleController, 'Job Title'),
//         _buildTextField(_companyController, 'Company'),
//         _buildTextField(_locationController, 'Location'),
//         _buildTextFieldWithDatePicker(_workFromController, 'From'),
//         _buildTextFieldWithDatePicker(_workToController, 'To'),
//         _buildTextField(_descriptionController, 'Description'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _workExperiences.add(WorkExperience(
//                     jobTitle: _jobTitleController.text,
//                     company: _companyController.text,
//                     location: _locationController.text,
//                     from: _workFromController.text,
//                     to: _workToController.text,
//                     description: _descriptionController.text,
//                   ));
//                   _jobTitleController.clear();
//                   _companyController.clear();
//                   _locationController.clear();
//                   _workFromController.clear();
//                   _workToController.clear();
//                   _descriptionController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Work Experience',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_workExperiences, (workExperience) {
//           return ListTile(
//             title:
//                 Text('${workExperience.jobTitle} at ${workExperience.company}'),
//             subtitle: Text('${workExperience.from} - ${workExperience.to}'),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildEducation() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Education'),
//         _buildTextField(_degreeController, 'Degree'),
//         _buildTextField(_institutionController, 'Institution'),
//         _buildTextField(_eduLocationController, 'Location'),
//         _buildTextField(_graduationYearController, 'Year of Graduation'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _educations.add(Education(
//                     degree: _degreeController.text,
//                     institution: _institutionController.text,
//                     location: _eduLocationController.text,
//                     graduationYear: _graduationYearController.text,
//                   ));
//                   _degreeController.clear();
//                   _institutionController.clear();
//                   _eduLocationController.clear();
//                   _graduationYearController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Education',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_educations, (education) {
//           return ListTile(
//             title: Text('${education.degree} from ${education.institution}'),
//             subtitle: Text('${education.graduationYear}'),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildSkills() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Skills'),
//         _buildTextField(_skillController, 'Skill'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _skills.add(_skillController.text);
//                   _skillController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Skill',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_skills, (skill) {
//           return ListTile(
//             title: Text(skill),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildLanguages() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Languages'),
//         _buildTextField(_languageNameController, 'Language'),
//         _buildTextField(_readingProficiencyController, 'Reading Proficiency'),
//         _buildTextField(_writingProficiencyController, 'Writing Proficiency'),
//         _buildTextField(_speakingProficiencyController, 'Speaking Proficiency'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _languages.add(LanguageSkill(
//                     name: _languageNameController.text,
//                     readingProficiency: _readingProficiencyController.text,
//                     writingProficiency: _writingProficiencyController.text,
//                     speakingProficiency: _speakingProficiencyController.text,
//                   ));
//                   _languageNameController.clear();
//                   _readingProficiencyController.clear();
//                   _writingProficiencyController.clear();
//                   _speakingProficiencyController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Language',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_languages, (languageSkill) {
//           return ListTile(
//             title: Text(languageSkill.name),
//             subtitle: Text(
//                 'Reading: ${languageSkill.readingProficiency}, Writing: ${languageSkill.writingProficiency}, Speaking: ${languageSkill.speakingProficiency}'),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildCertifications() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Certifications'),
//         _buildTextField(_certificationNameController, 'Certification Name'),
//         _buildTextField(_issuingOrganizationController, 'Issuing Organization'),
//         _buildTextFieldWithDatePicker(_certificationDateController, 'Date'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _certifications.add(Certification(
//                     name: _certificationNameController.text,
//                     issuingOrganization: _issuingOrganizationController.text,
//                     date: _certificationDateController.text,
//                   ));
//                   _certificationNameController.clear();
//                   _issuingOrganizationController.clear();
//                   _certificationDateController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Certification',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_certifications, (certification) {
//           return ListTile(
//             title: Text(certification.name),
//             subtitle: Text(
//                 '${certification.issuingOrganization} - ${certification.date}'),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildProjects() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Projects'),
//         _buildTextField(_projectTitleController, 'Project Title'),
//         _buildTextField(_projectDescriptionController, 'Description'),
//         _buildTextField(_technologiesUsedController, 'Technologies Used'),
//         _buildTextField(_roleController, 'Role'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _projects.add(Project(
//                     title: _projectTitleController.text,
//                     description: _projectDescriptionController.text,
//                     technologiesUsed: _technologiesUsedController.text,
//                     role: _roleController.text,
//                   ));
//                   _projectTitleController.clear();
//                   _projectDescriptionController.clear();
//                   _technologiesUsedController.clear();
//                   _roleController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Project',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_projects, (project) {
//           return ListTile(
//             title: Text(project.title),
//             subtitle: Text('${project.description} - Role: ${project.role}'),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildHobbies() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('Hobbies'),
//         _buildTextField(_hobbyNameController, 'Hobby'),
//         _buildTextField(_hobbyDescriptionController, 'Description'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _hobbies.add(Hobby(
//                     name: _hobbyNameController.text,
//                     description: _hobbyDescriptionController.text,
//                   ));
//                   _hobbyNameController.clear();
//                   _hobbyDescriptionController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Hobby',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_hobbies, (hobby) {
//           return ListTile(
//             title: Text(hobby.name),
//             subtitle: Text(hobby.description),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildReferences() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildSectionTitle('References'),
//         _buildTextField(_referenceNameController, 'Reference Name'),
//         _buildTextField(_referenceRelationshipController, 'Relationship'),
//         _buildTextField(_referenceContactController, 'Contact'),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               if (_formKey.currentState?.validate() ?? false) {
//                 setState(() {
//                   _references.add(Reference(
//                     name: _referenceNameController.text,
//                     relationship: _referenceRelationshipController.text,
//                     contact: _referenceContactController.text,
//                   ));
//                   _referenceNameController.clear();
//                   _referenceRelationshipController.clear();
//                   _referenceContactController.clear();
//                 });
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Add Reference',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//         _buildListView(_references, (reference) {
//           return ListTile(
//             title: Text(reference.name),
//             subtitle: Text('${reference.relationship} - ${reference.contact}'),
//           );
//         }),
//       ],
//     );
//   }

//   Widget _buildSaveButton() {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           if (_formKey.currentState?.validate() ?? false) {
//             // Handle save logic here
//             final cvData = {
//               'firstName': _firstNameController.text,
//               'lastName': _lastNameController.text,
//               'profileImageUrl': _profileImageUrl ??
//                   '', // Ensure this matches the field name in CVData
//               'aboutMe': _aboutMeController
//                   .text, // Assuming you have these controllers
//               'dob': _dobController.text,
//               'gender': _genderController.text,
//               'nationality': _nationalityController.text,
//               'email': _emailController.text,
//               'phone': _phoneController.text,
//               'linkedin': _linkedinController.text,
//               'portfolio': _portfolioController.text,
//               'instantMessaging': _instantMessagingController.text,
//               'website': _websiteController.text,
//               'address': _addressController.text,
//               'postalCode': _postalCodeController.text,
//               'country': _countryController.text,
//               'workExperiences':
//                   _workExperiences.map((e) => e.toMap()).toList(),
//               'educations': _educations.map((e) => e.toMap()).toList(),
//               'skills': _skills,
//               'languages': _languages.map((e) => e.toMap()).toList(),
//               'certifications': _certifications.map((e) => e.toMap()).toList(),
//               'projects': _projects.map((e) => e.toMap()).toList(),
//               'hobbies': _hobbies.map((e) => e.toMap()).toList(),
//               'references': _references.map((e) => e.toMap()).toList(),
//             };

//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => CVPreviewScreen(
//                   cvData: cvData,
//                 ),
//               ),
//             );
//           }
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.backgroundColor,
//         ),
//         child: Text(
//           'Save CV',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionNavigationButtons() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         if (_currentSectionIndex > 0)
//           ElevatedButton(
//             onPressed: _previousSection,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Previous',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         if (_currentSectionIndex < 9)
//           ElevatedButton(
//             onPressed: _nextSection,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.backgroundColor,
//             ),
//             child: Text(
//               'Next',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//       ],
//     );
//   }
// }

// class WorkExperience {
//   final String jobTitle;
//   final String company;
//   final String location;
//   final String from;
//   final String to;
//   final String description;

//   WorkExperience({
//     required this.jobTitle,
//     required this.company,
//     required this.location,
//     required this.from,
//     required this.to,
//     required this.description,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'jobTitle': jobTitle,
//       'company': company,
//       'location': location,
//       'from': from,
//       'to': to,
//       'description': description,
//     };
//   }
// }

// class Education {
//   final String degree;
//   final String institution;
//   final String location;
//   final String graduationYear;

//   Education({
//     required this.degree,
//     required this.institution,
//     required this.location,
//     required this.graduationYear,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'degree': degree,
//       'institution': institution,
//       'location': location,
//       'graduationYear': graduationYear,
//     };
//   }
// }

// class LanguageSkill {
//   final String name;
//   final String readingProficiency;
//   final String writingProficiency;
//   final String speakingProficiency;

//   LanguageSkill({
//     required this.name,
//     required this.readingProficiency,
//     required this.writingProficiency,
//     required this.speakingProficiency,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'readingProficiency': readingProficiency,
//       'writingProficiency': writingProficiency,
//       'speakingProficiency': speakingProficiency,
//     };
//   }
// }

// class Certification {
//   final String name;
//   final String issuingOrganization;
//   final String date;

//   Certification({
//     required this.name,
//     required this.issuingOrganization,
//     required this.date,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'issuingOrganization': issuingOrganization,
//       'date': date,
//     };
//   }
// }

// class Project {
//   final String title;
//   final String description;
//   final String technologiesUsed;
//   final String role;

//   Project({
//     required this.title,
//     required this.description,
//     required this.technologiesUsed,
//     required this.role,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'description': description,
//       'technologiesUsed': technologiesUsed,
//       'role': role,
//     };
//   }
// }

// class Hobby {
//   final String name;
//   final String description;

//   Hobby({
//     required this.name,
//     required this.description,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'description': description,
//     };
//   }
// }

// class Reference {
//   final String name;
//   final String relationship;
//   final String contact;

//   Reference({
//     required this.name,
//     required this.relationship,
//     required this.contact,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'relationship': relationship,
//       'contact': contact,
//     };
//   }
// }
