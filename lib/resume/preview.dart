// ignore_for_file: avoid_print, library_private_types_in_public_api, use_key_in_widget_constructors, unnecessary_to_list_in_spreads

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../colors/color.dart';

class ResumeScreen extends StatefulWidget {
  @override
  _ResumeScreenState createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? resumeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResumeData();
  }

  Future<void> fetchResumeData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      DocumentSnapshot doc = await _firestore
          .collection('user_resume')
          .doc(auth.currentUser!.uid)
          .get();
      setState(() {
        resumeData = doc;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching resume data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> generatePDF(DocumentSnapshot resumeData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Personal Information
              if (resumeData['firstName'] != null ||
                  resumeData['lastName'] != null)
                pw.Text(
                  '${resumeData['firstName'] ?? ''} ${resumeData['lastName'] ?? ''}',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              if (resumeData['email'] != null)
                pw.Text('Email: ${resumeData['email']}'),
              if (resumeData['phone'] != null)
                pw.Text('Phone: ${resumeData['phone']}'),
              if (resumeData['instantMessaging'] != null)
                pw.Text('Instant Messaging: ${resumeData['instantMessaging']}'),
              if (resumeData['linkedin'] != null)
                pw.Text('LinkedIn: ${resumeData['linkedin']}'),
              if (resumeData['country'] != null)
                pw.Text('Country: ${resumeData['country']}'),
              if (resumeData['address'] != null)
                pw.Text('Address: ${resumeData['address']}'),

              // About Me
              if (resumeData['aboutMe'] != null)
                pw.Column(
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Text('About Me',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    pw.Text(resumeData['aboutMe']),
                  ],
                ),

              // Work Experience
              if (resumeData['work_experiences'] is List)
                pw.Column(
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Text('Work Experience',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ...resumeData['work_experiences'].map<pw.Widget>((work) {
                      return pw.Column(
                        children: [
                          pw.Text('${work['job_title']} at ${work['company']}',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('${work['from']} - ${work['to']}'),
                          pw.Text(work['description'] ?? ''),
                          pw.SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                ),

              // Education Section
              if (resumeData['educations'] is List)
                pw.Column(
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Text('Education',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ...resumeData['educations'].map<pw.Widget>((education) {
                      return pw.Column(
                        children: [
                          pw.Text('${education['degree']}',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('${education['institution']}'),
                          pw.Text(
                              'Graduation Year: ${education['graduation_year']}'),
                          pw.SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                ),

              // Certifications Section
              if (resumeData['certifications'] is List)
                pw.Column(
                  children: [
                    pw.SizedBox(height: 20),
                    pw.Text('Certifications',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                    ...resumeData['certifications'].map<pw.Widget>((cert) {
                      return pw.Column(
                        children: [
                          pw.Text('${cert['name']}',
                              style:
                                  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                          pw.Text('Issued by: ${cert['issuingOrganization']}'),
                          pw.Text('Date: ${cert['dateObtained']}'),
                          pw.SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ],
                ),
            ],
          );
        },
      ),
    );

    // Printing the PDF
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Resume',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () =>
              Navigator.pop(context), // Navigates back to the previous screen
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.print,
              color: Colors.white,
            ),
            onPressed: () {
              if (resumeData != null) {
                generatePDF(resumeData!);
              }
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : resumeData != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Information
                        if (resumeData!['firstName'] != null ||
                            resumeData!['lastName'] != null ||
                            resumeData!['email'] != null ||
                            resumeData!['phone'] != null ||
                            resumeData!['address'] != null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 50.0,
                                backgroundImage: resumeData!['profileImage'] !=
                                        null
                                    ? NetworkImage(resumeData!['profileImage'])
                                    : AssetImage('assets/placeholder.png')
                                        as ImageProvider,
                              ),
                              SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${resumeData!['firstName'] ?? ''} ${resumeData!['lastName'] ?? ''}',
                                      style: TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (resumeData!['dob'] != "" ||
                                        resumeData!['gender'] != "" ||
                                        resumeData!['phone'] != "")
                                      SingleChildScrollView(
                                        child: Row(
                                          children: [
                                            if (resumeData!['dob'] != "")
                                              Text(
                                                  'Date of birth:${resumeData!['dob']} '),
                                            if (resumeData!['gender'] != "")
                                              Text(
                                                  'Gender:${resumeData!['gender']} '),
                                          ],
                                        ),
                                      ),
                                    if (resumeData!['email'] != "")
                                      Text('Email: ${resumeData!['email']}'),
                                    if (resumeData!['phone'] != "")
                                      Text('WhatsApp:${resumeData!['phone']}'),
                                    if (resumeData!['instantMessaging'] != "")
                                      Text(
                                          'Phone: ${resumeData!['instantMessaging']}'),
                                    if (resumeData!['linkedin'] != "")
                                      Text(
                                          'Linkedin: ${resumeData!['linkedin']}'),
                                    if (resumeData!['country'] != null)
                                      Text(
                                          'Country: ${resumeData!['country']}'),
                                    if (resumeData!['address'] != "")
                                      Text(
                                          'Address: ${resumeData!['address']}'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 16.0),
                        // About Myself
                        if (resumeData!['aboutMe'] != "")
                          buildSection('About Me', resumeData!['aboutMe']),
                        SizedBox(height: 16.0),
                        // Work Experience Section
                        if (resumeData!['work_experiences'] is List &&
                            (resumeData!['work_experiences'] as List)
                                .isNotEmpty)
                          buildExperienceSection('Work Experience',
                              resumeData!['work_experiences']),
                        // Education Section
                        if (resumeData!['educations'] is List &&
                            (resumeData!['educations'] as List).isNotEmpty)
                          buildEducationSection(
                              'Education', resumeData!['educations']),
                        // Certifications Section
                        if (resumeData!['certifications'] is List &&
                            (resumeData!['certifications'] as List).isNotEmpty)
                          buildCertificationsSection(
                              'Certifications', resumeData!['certifications']),
                      ],
                    ),
                  ),
                )
              : Center(child: Text('No data available')),
    );
  }

  Widget buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Divider(color: Colors.black),
        SizedBox(height: 8.0),
        Text(content),
      ],
    );
  }

  Widget buildExperienceSection(String title, List experiences) {
    return buildListSection(title, experiences, (work) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (work['job_title'] != "")
            Text('${work['job_title']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (work['company'] != "")
            Text('${work['company']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (work['from'] != "" || work['to'] != "")
            Text('${work['from'] ?? ''} - ${work['to'] ?? ''}'),
          SizedBox(height: 8.0),
          if (work['description'] != "") Text(work['description']),
          SizedBox(height: 12.0),
        ],
      );
    });
  }

  Widget buildEducationSection(String title, List educations) {
    return buildListSection(title, educations, (education) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (education['degree'] != "")
            Text('${education['degree']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (education['institution'] != "")
            Text('${education['institution']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (education['graduation_year'] != "")
            Text('Graduation Year: ${education['graduation_year']}'),
          SizedBox(height: 12.0),
        ],
      );
    });
  }

  Widget buildCertificationsSection(String title, List certifications) {
    return buildListSection(title, certifications, (cert) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (cert['name'] != "")
            Text('${cert['name']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          if (cert['issuingOrganization'] != "")
            Text('Issued by: ${cert['issuingOrganization']}'),
          if (cert['dateObtained'] != "") Text('Date: ${cert['dateObtained']}'),
          SizedBox(height: 12.0),
        ],
      );
    });
  }

  Widget buildListSection(
      String title, List items, Widget Function(Map<String, dynamic>) builder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        Divider(color: Colors.black),
        SizedBox(height: 8.0),
        ...items.map((item) => builder(item)).toList(),
      ],
    );
  }
}
