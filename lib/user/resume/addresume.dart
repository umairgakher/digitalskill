// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:digitalskill/colors/color.dart';
// import 'package:digitalskill/user/resume/resumelistingadmin.dart';
// import 'package:digitalskill/widget/appbar.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:path/path.dart' as path;

// import 'resumetamplate.dart';

// class AddResumes extends StatefulWidget {
//   @override
//   _AddResumesState createState() => _AddResumesState();
// }

// class _AddResumesState extends State<AddResumes> {
//   File? _documentFile;
//   List<File> _imageFiles = [];
//   final ImagePicker _imagePicker = ImagePicker();
//   final TextEditingController _cvNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "Add Resume",
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(width * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildCvNameField(width, height),
//               SizedBox(height: height * 0.03),
//               _buildDocumentPicker(width, height),
//               SizedBox(height: height * 0.03),
//               _buildImagePicker(width, height),
//               SizedBox(height: height * 0.03),
//               _buildSubmitButton(width, height),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCvNameField(double width, double height) {
//     return Container(
//       padding: EdgeInsets.all(width * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(width * 0.03),
//         border: Border.all(color: AppColors.backgroundColor),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: width * 0.02,
//             offset: Offset(0, height * 0.005),
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: _cvNameController,
//         decoration: InputDecoration(
//           labelText: 'CV Name',
//           border: OutlineInputBorder(),
//           prefixIcon: Icon(Icons.title, color: AppColors.backgroundColor),
//         ),
//       ),
//     );
//   }

//   Widget _buildDocumentPicker(double width, double height) {
//     return Container(
//       padding: EdgeInsets.all(width * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(width * 0.03),
//         border: Border.all(color: AppColors.backgroundColor),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: width * 0.02,
//             offset: Offset(0, height * 0.005),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(
//                 Icons.insert_drive_file,
//                 size: width * 0.06,
//                 color: AppColors.backgroundColor,
//               ),
//               SizedBox(width: width * 0.02),
//               Text(
//                 'Upload Resume (Document)',
//                 style: TextStyle(
//                   fontSize: width * 0.04,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: height * 0.01),
//           _documentFile != null
//               ? Text(
//                   path.basename(_documentFile!.path),
//                   style: TextStyle(
//                     fontSize: width * 0.035,
//                     color: Colors.black54,
//                   ),
//                 )
//               : Container(
//                   height: height * 0.13,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(width * 0.02),
//                     border: Border.all(color: AppColors.backgroundColor),
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.insert_drive_file,
//                       size: width * 0.13,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//           SizedBox(height: height * 0.015),
//           Center(
//             child: IconButton(
//               icon: Icon(Icons.insert_drive_file,
//                   size: width * 0.08, color: AppColors.backgroundColor),
//               onPressed: _pickDocument,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildImagePicker(double width, double height) {
//     return Container(
//       padding: EdgeInsets.all(width * 0.04),
//       decoration: BoxDecoration(
//         color: Colors.grey[200],
//         borderRadius: BorderRadius.circular(width * 0.03),
//         border: Border.all(color: AppColors.backgroundColor),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: width * 0.02,
//             offset: Offset(0, height * 0.005),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Upload Images',
//             style: TextStyle(
//               fontSize: width * 0.04,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//           ),
//           SizedBox(height: height * 0.01),
//           _imageFiles.isNotEmpty
//               ? Wrap(
//                   spacing: width * 0.02,
//                   runSpacing: width * 0.02,
//                   children: _imageFiles.map((file) {
//                     return ClipRRect(
//                       borderRadius: BorderRadius.circular(width * 0.02),
//                       child: Image.file(
//                         file,
//                         width: width * 0.25,
//                         height: height * 0.13,
//                         fit: BoxFit.cover,
//                       ),
//                     );
//                   }).toList(),
//                 )
//               : Container(
//                   height: height * 0.13,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     color: Colors.transparent,
//                     borderRadius: BorderRadius.circular(width * 0.02),
//                     border: Border.all(color: AppColors.backgroundColor),
//                   ),
//                   child: Center(
//                     child: Icon(
//                       Icons.add_photo_alternate,
//                       size: width * 0.13,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ),
//           SizedBox(height: height * 0.015),
//           Center(
//             child: IconButton(
//               icon: Icon(Icons.add_photo_alternate,
//                   size: width * 0.08, color: AppColors.backgroundColor),
//               onPressed: _pickImages,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSubmitButton(double width, double height) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: _submitForm,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.backgroundColor,
//           padding: EdgeInsets.symmetric(
//               horizontal: width * 0.1, vertical: height * 0.02),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(width * 0.02),
//           ),
//         ),
//         child: Text(
//           'Submit',
//           style: TextStyle(fontSize: width * 0.04, color: Colors.white),
//         ),
//       ),
//     );
//   }

//   Future<void> _pickDocument() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );

//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _documentFile = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> _pickImages() async {
//     final pickedFiles = await _imagePicker.pickMultiImage();

//     if (pickedFiles != null) {
//       setState(() {
//         _imageFiles =
//             pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
//       });
//     }
//   }

//   Future<void> _submitForm() async {
//     if (_cvNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a CV name')),
//       );
//       return;
//     }

//     if (_documentFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select a document')),
//       );
//       return;
//     }

//     if (_imageFiles.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please select at least one image')),
//       );
//       return;
//     }

//     // Show loading spinner
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Center(
//         child: CircularProgressIndicator(),
//       ),
//     );

//     try {
//       // Upload document
//       String documentUrl = await _uploadFileToFirebaseStorage(_documentFile!);

//       // Upload images
//       List<String> imageUrls = [];
//       for (File imageFile in _imageFiles) {
//         String imageUrl = await _uploadFileToFirebaseStorage(imageFile);
//         imageUrls.add(imageUrl);
//       }

//       // Save data to Firestore
//       await FirebaseFirestore.instance.collection('resumes').add({
//         'cv_name': _cvNameController.text,
//         'document_url': documentUrl,
//         'image_urls': imageUrls,
//       });

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Resume added successfully')),
//       );

//       // Clear form after submission
//       setState(() {
//         _cvNameController.clear();
//         _documentFile = null;
//         _imageFiles = [];
//       });

//       // Dismiss loading spinner
//       // Navigator.of(context).pop();

//       // Navigate to the ResumeTemplate page after successful submission
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ResumeListScreen()),
//       );
//     } catch (e) {
//       // Dismiss loading spinner
//       Navigator.of(context).pop();

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to add resume: $e')),
//       );
//     }
//   }

//   Future<String> _uploadFileToFirebaseStorage(File file) async {
//     String fileName = path.basename(file.path);
//     Reference storageReference =
//         FirebaseStorage.instance.ref().child('resumes/$fileName');
//     UploadTask uploadTask = storageReference.putFile(file);
//     TaskSnapshot taskSnapshot = await uploadTask;
//     return await taskSnapshot.ref.getDownloadURL();
//   }
// }
