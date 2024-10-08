// // ignore_for_file: unnecessary_cast, sort_child_properties_last

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:digitalskill/colors/color.dart';
// import 'package:digitalskill/user/resume/addresume.dart';
// import 'package:digitalskill/user/resume/edit_resume.dart';
// import 'package:digitalskill/widget/appbar.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:path/path.dart';

// class ResumeListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;

//     return Scaffold(
//       appBar: CustomAppBar(title: "Resumes"),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('resumes').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
//             return Center(child: Text("No resumes available"));
//           }

//           final resumes = snapshot.data!.docs;

//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: isPortrait ? 2 : 3,
//               crossAxisSpacing: 16.0,
//               mainAxisSpacing: 16.0,
//               childAspectRatio: (width / 4) / (height / 6),
//             ),
//             itemCount: resumes.length,
//             itemBuilder: (context, index) {
//               final resume = resumes[index].data() as Map<String, dynamic>;
//               final imageUrls =
//                   List<String>.from(resume['image_urls'] as List<dynamic>);
//               final cvName = resume['cv_name'] ?? 'No Name';

//               return GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => EditResumeScreen(
//                           resumeId: resumes[index].id, resume: resume),
//                     ),
//                   );
//                 },
//                 child: Stack(
//                   clipBehavior: Clip.none,
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: imageUrls.isNotEmpty
//                               ? NetworkImage(imageUrls.first)
//                               : const AssetImage("assets/images/CVResume.png")
//                                   as ImageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                         color: Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     Positioned(
//                       top: 8,
//                       left: 8,
//                       right: 8,
//                       child: Text(
//                         cvName,
//                         style: TextStyle(
//                             fontSize: 24.0,
//                             fontWeight: FontWeight.bold,
//                             color: AppColors.backgroundColor),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 8,
//                       right: 8,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: Icon(Icons.edit,
//                                 color: AppColors.backgroundColor),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => EditResumeScreen(
//                                       resumeId: resumes[index].id,
//                                       resume: resume),
//                                 ),
//                               );
//                             },
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.delete,
//                                 color: AppColors.backgroundColor),
//                             onPressed: () async {
//                               await _deleteResume(resumes[index].id);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => AddResumes()),
//           );
//         },
//         child: Icon(Icons.add, color: Colors.white),
//         backgroundColor: AppColors.backgroundColor,
//       ),
//     );
//   }

//   Future<void> _deleteResume(String resumeId) async {
//     final resumeRef =
//         FirebaseFirestore.instance.collection('resumes').doc(resumeId);

//     final resumeData = (await resumeRef.get()).data() as Map<String, dynamic>?;
//     if (resumeData != null) {
//       final imageUrls =
//           List<String>.from(resumeData['image_urls'] as List<dynamic>);
//       final documentUrl = resumeData['document_url'] as String?;

//       for (var url in imageUrls) {
//         await FirebaseStorage.instance.refFromURL(url).delete();
//       }
//       if (documentUrl != null) {
//         await FirebaseStorage.instance.refFromURL(documentUrl).delete();
//       }

//       await resumeRef.delete();

//       ScaffoldMessenger.of(context as BuildContext).showSnackBar(
//         SnackBar(content: Text('Resume deleted successfully!')),
//       );
//     }
//   }
// }
