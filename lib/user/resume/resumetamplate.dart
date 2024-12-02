// // ignore_for_file: non_constant_identifier_names

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:digitalskill/resume/cv_builder_screen.dart.dart';
// import 'package:digitalskill/widget/appbar.dart';
// import 'package:flutter/material.dart'; // Update with your actual path
// import 'resumeform.dart';

// class ResumeTemplateScreen extends StatefulWidget {
//   @override
//   State<ResumeTemplateScreen> createState() => _ResumeTemplateScreenState();
// }

// class _ResumeTemplateScreenState extends State<ResumeTemplateScreen> {
//   // Future to fetch resume details from Firestore
//   Future<List<Map<String, dynamic>>> fetchResumeTemplates() async {
//     try {
//       QuerySnapshot snapshot = await FirebaseFirestore.instance
//           .collection('resumes') // Your collection name
//           .get();

//       // Convert each document to a Map and collect them in a list
//       return snapshot.docs
//           .map((doc) => doc.data() as Map<String, dynamic>)
//           .toList();
//     } catch (e) {
//       print('Error fetching resume templates: $e');
//     }
//     return [];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final padding = 16.0;
//     final fontSizeTitle = 24.0;
//     final gridSpacing = 16.0;

//     return Scaffold(
//       appBar: CustomAppBar(title: 'Resume Create'),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: fetchResumeTemplates(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error fetching resume templates'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No resume templates found'));
//           } else {
//             final resumeTemplates = snapshot.data!;

//             return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(padding),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Choose Template',
//                       style: TextStyle(
//                           fontSize: fontSizeTitle, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: height * 0.02),
//                     GridView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: gridSpacing,
//                         mainAxisSpacing: gridSpacing,
//                         childAspectRatio: (width / 4) / (height / 6),
//                       ),
//                       itemCount: resumeTemplates.length,
//                       itemBuilder: (context, index) {
//                         final template = resumeTemplates[index];
//                         final document_url = template['document_url'] ?? '';
//                         final image_urls =
//                             template['image_urls'] as List<dynamic>? ?? [];
//                         final imageUrl = image_urls.isNotEmpty
//                             ? image_urls[0]
//                             : ''; // Use the first image

//                         return Stack(
//                           clipBehavior: Clip.none,
//                           children: [
//                             Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: imageUrl.isNotEmpty
//                                       ? NetworkImage(imageUrl)
//                                       : const AssetImage(
//                                               "assets/images/CVResume.png")
//                                           as ImageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 color: Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             Positioned(
//                               bottom: 8,
//                               right: 8,
//                               child: IconButton(
//                                 icon: Icon(Icons.edit_outlined,
//                                     size: height * 0.04),
//                                 onPressed: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => CVBuilderScreen(),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
