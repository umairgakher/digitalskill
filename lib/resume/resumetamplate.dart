// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class CVPreviewScreen extends StatelessWidget {
//   final Map<String, dynamic> cvData;

//   CVPreviewScreen({required this.cvData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('CV Preview'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () => _generateAndDownloadPdf(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildProfileImage(),
//             SizedBox(height: 24),
//             _buildSection('Personal Information', _buildPersonalInfo()),
//             _buildDivider(),
//             _buildSection('Work Experience', _buildWorkExperiences()),
//             _buildDivider(),
//             _buildSection('Education', _buildEducations()),
//             _buildDivider(),
//             _buildSection('Skills', _buildSkills()),
//             _buildDivider(),
//             _buildSection('Languages', _buildLanguages()),
//             _buildDivider(),
//             _buildSection('Certifications', _buildCertifications()),
//             _buildDivider(),
//             _buildSection('Projects', _buildProjects()),
//             _buildDivider(),
//             _buildSection('Hobbies', _buildHobbies()),
//             _buildDivider(),
//             _buildSection('References', _buildReferences()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileImage() {
//     return Center(
//       child: CircleAvatar(
//         radius: 75,
//         backgroundImage:
//             cvData['profileImage'] != null && cvData['profileImage'] is File
//                 ? FileImage(cvData['profileImage'] as File)
//                 : null,
//         child: cvData['profileImage'] == null
//             ? Icon(Icons.person, size: 75)
//             : null,
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<Widget> content) {
//     if (content.isEmpty)
//       return SizedBox.shrink(); // Don't show section if empty

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 12.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.blueGrey[800],
//             ),
//           ),
//           SizedBox(height: 8),
//           Container(
//             padding: EdgeInsets.all(12.0),
//             decoration: BoxDecoration(
//               color: Colors.grey[100],
//               borderRadius: BorderRadius.circular(8.0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.2),
//                   spreadRadius: 2,
//                   blurRadius: 4,
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: content,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Divider(color: Colors.grey),
//     );
//   }

//   List<Widget> _buildPersonalInfo() {
//     return [
//       _buildInfoRow('Name', '${cvData['firstName']} ${cvData['lastName']}'),
//       _buildInfoRow('Email', cvData['email']),
//       _buildInfoRow('Phone', cvData['phone']),
//       _buildInfoRow('LinkedIn', cvData['linkedin']),
//       _buildInfoRow('Website', cvData['website']),
//     ];
//   }

//   Widget _buildInfoRow(String label, String value) {
//     return value.isEmpty
//         ? SizedBox.shrink() // Don't show row if value is empty
//         : Padding(
//             padding: const EdgeInsets.symmetric(vertical: 4.0),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '$label: ',
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
//                 ),
//                 Expanded(
//                   child: Text(value, style: TextStyle(color: Colors.black87)),
//                 ),
//               ],
//             ),
//           );
//   }

//   List<Widget> _buildWorkExperiences() {
//     final workExperiences = (cvData['workExperiences'] as List?)
//         ?.where((work) => work['jobTitle'] != null)
//         .map((work) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Job Title: ${work['jobTitle']}',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
//             Text('Company: ${work['company']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('Location: ${work['location']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('From: ${work['from']} To: ${work['to']}',
//                 style: TextStyle(color: Colors.black87)),
//             SizedBox(height: 4),
//             Text('Description: ${work['description']}',
//                 style: TextStyle(color: Colors.black87)),
//           ],
//         ),
//       );
//     }).toList();

//     return workExperiences ?? [];
//   }

//   List<Widget> _buildEducations() {
//     final educations = (cvData['educations'] as List?)
//         ?.where((edu) => edu['degree'] != null)
//         .map((edu) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Degree: ${edu['degree']}',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
//             Text('Institution: ${edu['institution']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('Location: ${edu['location']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('Year: ${edu['graduationYear']}',
//                 style: TextStyle(color: Colors.black87)),
//           ],
//         ),
//       );
//     }).toList();

//     return educations ?? [];
//   }

//   List<Widget> _buildSkills() {
//     final skills = (cvData['skills'] as List?)
//         ?.where((skill) => skill != null)
//         .map((skill) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 4.0),
//         child: Text('• $skill', style: TextStyle(color: Colors.black87)),
//       );
//     }).toList();

//     return skills ?? [];
//   }

//   List<Widget> _buildLanguages() {
//     final languages = (cvData['languages'] as List?)
//         ?.where((lang) => lang['name'] != null)
//         .map((lang) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 4.0),
//         child: Text(
//           '• ${lang['name']} - Reading: ${lang['readingProficiency']}, Writing: ${lang['writingProficiency']}, Speaking: ${lang['speakingProficiency']}',
//           style: TextStyle(color: Colors.black87),
//         ),
//       );
//     }).toList();

//     return languages ?? [];
//   }

//   List<Widget> _buildCertifications() {
//     final certifications = (cvData['certifications'] as List?)
//         ?.where((cert) => cert['name'] != null)
//         .map((cert) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 4.0),
//         child: Text(
//             '• ${cert['name']} - ${cert['issuingOrganization']} (${cert['date']})',
//             style: TextStyle(color: Colors.black87)),
//       );
//     }).toList();

//     return certifications ?? [];
//   }

//   List<Widget> _buildProjects() {
//     final projects = (cvData['projects'] as List?)
//         ?.where((proj) => proj['title'] != null)
//         .map((proj) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Title: ${proj['title']}',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
//             Text('Description: ${proj['description']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('Technologies: ${proj['technologiesUsed']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('Role: ${proj['role']}',
//                 style: TextStyle(color: Colors.black87)),
//           ],
//         ),
//       );
//     }).toList();

//     return projects ?? [];
//   }

//   List<Widget> _buildHobbies() {
//     final hobbies = (cvData['hobbies'] as List?)
//         ?.where((hobby) => hobby != null)
//         .map((hobby) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 4.0),
//         child: Text('• $hobby', style: TextStyle(color: Colors.black87)),
//       );
//     }).toList();

//     return hobbies ?? [];
//   }

//   List<Widget> _buildReferences() {
//     final references = (cvData['references'] as List?)
//         ?.where((ref) => ref['name'] != null)
//         .map((ref) {
//       return Padding(
//         padding: const EdgeInsets.only(bottom: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Name: ${ref['name']}',
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold, color: Colors.blueGrey[800])),
//             Text('Position: ${ref['position']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('Company: ${ref['company']}',
//                 style: TextStyle(color: Colors.black87)),
//             Text('Contact: ${ref['contact']}',
//                 style: TextStyle(color: Colors.black87)),
//           ],
//         ),
//       );
//     }).toList();

//     return references ?? [];
//   }

//   Future<void> _generateAndDownloadPdf(BuildContext context) async {
//     final pdf = pw.Document();
//     final profileImageProvider =
//         cvData['profileImage'] != null && cvData['profileImage'] is File
//             ? pw.MemoryImage(
//                 (cvData['profileImage'] as File).readAsBytesSync(),
//               )
//             : null;

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) => pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Center(
//               child: pw.Container(
//                 width: 100,
//                 height: 100,
//                 decoration: pw.BoxDecoration(
//                   shape: pw.BoxShape.circle,
//                   image: profileImageProvider != null
//                       ? pw.DecorationImage(
//                           image: profileImageProvider,
//                           fit: pw.BoxFit.cover,
//                         )
//                       : null,
//                   color: PdfColors.grey300, // Fallback color if image is null
//                 ),
//               ),
//             ),
//             pw.SizedBox(height: 16),
//             _buildPdfSection('Personal Information', _buildPdfPersonalInfo()),
//             pw.Divider(),
//             _buildPdfSection('Work Experience', _buildPdfWorkExperiences()),
//             pw.Divider(),
//             _buildPdfSection('Education', _buildPdfEducations()),
//             pw.Divider(),
//             _buildPdfSection('Skills', _buildPdfSkills()),
//             pw.Divider(),
//             _buildPdfSection('Languages', _buildPdfLanguages()),
//             pw.Divider(),
//             _buildPdfSection('Certifications', _buildPdfCertifications()),
//             pw.Divider(),
//             _buildPdfSection('Projects', _buildPdfProjects()),
//             pw.Divider(),
//             _buildPdfSection('Hobbies', _buildPdfHobbies()),
//             pw.Divider(),
//             _buildPdfSection('References', _buildPdfReferences()),
//           ],
//         ),
//       ),
//     );

//     final output = await getTemporaryDirectory();
//     final file = File("${output.path}/cv_preview.pdf");
//     await file.writeAsBytes(await pdf.save());

//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => PDFViewerPage(path: file.path)));
//   }

//   pw.Widget _buildPdfSection(String title, List<pw.Widget> content) {
//     if (content.isEmpty) return pw.SizedBox.shrink();

//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 12.0),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             title,
//             style: pw.TextStyle(
//               fontSize: 18,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//           pw.SizedBox(height: 8),
//           pw.Column(
//             crossAxisAlignment: pw.CrossAxisAlignment.start,
//             children: content,
//           ),
//         ],
//       ),
//     );
//   }

//   List<pw.Widget> _buildPdfPersonalInfo() {
//     return [
//       _buildPdfInfoRow('Name', '${cvData['firstName']} ${cvData['lastName']}'),
//       _buildPdfInfoRow('Email', cvData['email']),
//       _buildPdfInfoRow('Phone', cvData['phone']),
//       _buildPdfInfoRow('LinkedIn', cvData['linkedin']),
//       _buildPdfInfoRow('Website', cvData['website']),
//     ];
//   }

//   pw.Widget _buildPdfInfoRow(String label, String value) {
//     return pw.Padding(
//       padding: const pw.EdgeInsets.symmetric(vertical: 4.0),
//       child: pw.Row(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             '$label: ',
//             style: pw.TextStyle(
//                 fontWeight: pw.FontWeight.bold, color: PdfColors.blueGrey800),
//           ),
//           pw.Expanded(
//             child: pw.Text(value, style: pw.TextStyle(color: PdfColors.black)),
//           ),
//         ],
//       ),
//     );
//   }

//   List<pw.Widget> _buildPdfWorkExperiences() {
//     final workExperiences = (cvData['workExperiences'] as List?)
//         ?.where((work) => work['jobTitle'] != null)
//         .map((work) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 8.0),
//         child: pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('Job Title: ${work['jobTitle']}',
//                 style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.blueGrey800)),
//             pw.Text('Company: ${work['company']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('Location: ${work['location']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('From: ${work['from']} To: ${work['to']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.SizedBox(height: 4),
//             pw.Text('Description: ${work['description']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//           ],
//         ),
//       );
//     }).toList();

//     return workExperiences ?? [];
//   }

//   List<pw.Widget> _buildPdfEducations() {
//     final educations = (cvData['educations'] as List?)
//         ?.where((edu) => edu['degree'] != null)
//         .map((edu) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 8.0),
//         child: pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('Degree: ${edu['degree']}',
//                 style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.blueGrey800)),
//             pw.Text('Institution: ${edu['institution']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('Location: ${edu['location']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('Year: ${edu['graduationYear']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//           ],
//         ),
//       );
//     }).toList();

//     return educations ?? [];
//   }

//   List<pw.Widget> _buildPdfSkills() {
//     final skills = (cvData['skills'] as List?)
//         ?.where((skill) => skill != null)
//         .map((skill) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 4.0),
//         child: pw.Text('• $skill', style: pw.TextStyle(color: PdfColors.black)),
//       );
//     }).toList();

//     return skills ?? [];
//   }

//   List<pw.Widget> _buildPdfLanguages() {
//     final languages = (cvData['languages'] as List?)
//         ?.where((lang) => lang['name'] != null)
//         .map((lang) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 4.0),
//         child: pw.Text(
//           '• ${lang['name']} - Reading: ${lang['readingProficiency']}, Writing: ${lang['writingProficiency']}, Speaking: ${lang['speakingProficiency']}',
//           style: pw.TextStyle(color: PdfColors.black),
//         ),
//       );
//     }).toList();

//     return languages ?? [];
//   }

//   List<pw.Widget> _buildPdfCertifications() {
//     final certifications = (cvData['certifications'] as List?)
//         ?.where((cert) => cert['name'] != null)
//         .map((cert) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 4.0),
//         child: pw.Text(
//             '• ${cert['name']} - ${cert['issuingOrganization']} (${cert['date']})',
//             style: pw.TextStyle(color: PdfColors.black)),
//       );
//     }).toList();

//     return certifications ?? [];
//   }

//   List<pw.Widget> _buildPdfProjects() {
//     final projects = (cvData['projects'] as List?)
//         ?.where((proj) => proj['title'] != null)
//         .map((proj) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 8.0),
//         child: pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('Title: ${proj['title']}',
//                 style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.blueGrey800)),
//             pw.Text('Description: ${proj['description']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('Technologies: ${proj['technologiesUsed']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('Role: ${proj['role']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//           ],
//         ),
//       );
//     }).toList();

//     return projects ?? [];
//   }

//   List<pw.Widget> _buildPdfHobbies() {
//     final hobbies = (cvData['hobbies'] as List?)
//         ?.where((hobby) => hobby != null)
//         .map((hobby) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 4.0),
//         child: pw.Text('• $hobby', style: pw.TextStyle(color: PdfColors.black)),
//       );
//     }).toList();

//     return hobbies ?? [];
//   }

//   List<pw.Widget> _buildPdfReferences() {
//     final references = (cvData['references'] as List?)
//         ?.where((ref) => ref['name'] != null)
//         .map((ref) {
//       return pw.Padding(
//         padding: const pw.EdgeInsets.only(bottom: 8.0),
//         child: pw.Column(
//           crossAxisAlignment: pw.CrossAxisAlignment.start,
//           children: [
//             pw.Text('Name: ${ref['name']}',
//                 style: pw.TextStyle(
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColors.blueGrey800)),
//             pw.Text('Position: ${ref['position']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('Company: ${ref['company']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//             pw.Text('Contact: ${ref['contact']}',
//                 style: pw.TextStyle(color: PdfColors.black)),
//           ],
//         ),
//       );
//     }).toList();

//     return references ?? [];
//   }
// }

// class PDFViewerPage extends StatelessWidget {
//   final String path;

//   const PDFViewerPage({Key? key, required this.path}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('CV PDF Preview'),
//       ),
//       body: SfPdfViewer.file(File(path)),
//     );
//   }
// }
