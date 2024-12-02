// // ignore_for_file: use_build_context_synchronously

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:digitalskill/colors/color.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:path/path.dart' as path;

// class EditResumeScreen extends StatefulWidget {
//   final String resumeId;
//   final Map<String, dynamic> resume;

//   EditResumeScreen({required this.resumeId, required this.resume});

//   @override
//   _EditResumeScreenState createState() => _EditResumeScreenState();
// }

// class _EditResumeScreenState extends State<EditResumeScreen> {
//   final ImagePicker _imagePicker = ImagePicker();
//   File? _newImageFile;
//   List<File>? _newImageFiles;
//   File? _newDocumentFile;

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final imageUrls =
//         List<String>.from(widget.resume['image_urls'] as List<dynamic>);
//     final documentUrl = widget.resume['document_url'] as String?;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Edit Resume"),
//         backgroundColor: AppColors.backgroundColor,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (imageUrls.isNotEmpty)
//               Image.network(
//                 imageUrls.first,
//                 width: width * 0.5,
//                 height: height * 0.3,
//                 fit: BoxFit.cover,
//               ),
//             SizedBox(height: height * 0.02),
//             ElevatedButton(
//               onPressed: _pickNewDocument,
//               child: Text("Change Document"),
//             ),
//             ElevatedButton(
//               onPressed: _pickNewImages,
//               child: Text("Change Images"),
//             ),
//             Spacer(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text("Cancel"),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: _updateResume,
//                   child: Text("Save"),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _pickNewDocument() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx'],
//     );

//     if (result != null && result.files.single.path != null) {
//       setState(() {
//         _newDocumentFile = File(result.files.single.path!);
//       });
//     }
//   }

//   Future<void> _pickNewImages() async {
//     final pickedFiles = await _imagePicker.pickMultiImage();

//     if (pickedFiles != null) {
//       setState(() {
//         _newImageFiles =
//             pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
//       });
//     }
//   }

//   Future<void> _updateResume() async {
//     if (widget.resumeId.isEmpty) return;

//     final resumeRef =
//         FirebaseFirestore.instance.collection('resumes').doc(widget.resumeId);

//     // Upload new document if selected
//     String? newDocumentUrl;
//     if (_newDocumentFile != null) {
//       newDocumentUrl =
//           await _uploadFileToFirebaseStorage(_newDocumentFile!, 'resumes');
//     }

//     // Upload new images if selected
//     List<String>? newImageUrls;
//     if (_newImageFiles != null && _newImageFiles!.isNotEmpty) {
//       newImageUrls = await Future.wait(
//         _newImageFiles!.map(
//             (imageFile) => _uploadFileToFirebaseStorage(imageFile, 'resumes')),
//       );
//     }

//     // Update Firestore document
//     await resumeRef.update({
//       if (newDocumentUrl != null) 'document_url': newDocumentUrl,
//       if (newImageUrls != null) 'image_urls': newImageUrls,
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Resume updated successfully!')),
//     );

//     Navigator.pop(context);
//   }

//   Future<String> _uploadFileToFirebaseStorage(File file, String folder) async {
//     final fileName = path.basename(file.path);
//     final ref = FirebaseStorage.instance.ref().child('$folder/$fileName');
//     final uploadTask = ref.putFile(file);

//     final snapshot = await uploadTask.whenComplete(() {});
//     final downloadUrl = await snapshot.ref.getDownloadURL();
//     return downloadUrl;
//   }
// }
