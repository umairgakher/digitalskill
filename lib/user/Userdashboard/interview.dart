// ignore_for_file: sort_child_properties_last, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../colors/color.dart';
import '../../interview/Interview_questions_screen.dart';
import '../../interview/editinterview.dart';
import '../../interview/user_interview.dart';
import '../../loginsignup/login_controller.dart';
import '../../widget/appbar.dart';

class InterviewScreen extends StatefulWidget {
  const InterviewScreen({super.key});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  String? userEmail;
  List<Map<String, dynamic>> interviews = [];

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _fetchInterviews(); // Fetch the interviews when the screen initializes
  }

  Future<void> _fetchCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email;
    });
  }

  Future<void> _fetchInterviews() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('interviews')
          .get(); // Adjust the collection path as needed
      final List<Map<String, dynamic>> fetchedInterviews =
          result.docs.map((doc) {
        return {
          'id': doc.id, // Store document ID
          ...doc.data() as Map<String, dynamic>, // Include all document data
        };
      }).toList();

      setState(() {
        interviews = fetchedInterviews;
      });
    } catch (e) {
      print('Error fetching interviews: $e');
    }
  }

  Future<void> _deleteInterview(String interviewId) async {
    try {
      await FirebaseFirestore.instance
          .collection('interviews')
          .doc(interviewId)
          .delete(); // Delete the interview document
      _fetchInterviews(); // Refresh the list after deletion
      print('Interview deleted: $interviewId');
    } catch (e) {
      print('Error deleting interview: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: loginController().checkuser == 'admin'
          ? CustomAppBar(title: "Courses")
          : null,
      body: ListView.builder(
        itemCount: interviews.length, // Use the length of the interviews list
        itemBuilder: (context, index) {
          final interview = interviews[index];
          return Padding(
            padding: EdgeInsets.all(screenHeight * 0.02),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenHeight * 0.01),
              ),
              child: ListTile(
                onTap: () {
                  // Print the interview details to check if it has values
                  print("Interview tapped: $interview");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          loginController().checkuser == 'admin'
                              ? AdminEditInterviewPage(
                                  interviewId: interview['id'],
                                  interview: interview,
                                )
                              : UserInterviewsPage(
                                  InterviewId: interview['id'],
                                  interview: interview,
                                ),
                    ),
                  );
                },
                leading: Container(
                  width: screenWidth * 0.1,
                  height: screenWidth * 0.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: Icon(Icons.image,
                      color: Colors.grey, size: screenWidth * 0.05),
                ),
                title: Text(
                  interview['course_name'] ?? 'No Title',
                  style: TextStyle(fontSize: screenHeight * 0.02),
                ),
                subtitle: Text(
                  interview['description'] ?? 'No Description',
                  style: TextStyle(fontSize: screenHeight * 0.018),
                ),
                trailing: loginController().checkuser == 'admin'
                    ? IconButton(
                        icon: Icon(Icons.delete,
                            color: AppColors.backgroundColor),
                        onPressed: () {
                          // Confirm deletion before proceeding
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Delete Interview'),
                              content: Text(
                                  'Are you sure you want to delete this interview?'),
                              actions: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                ),
                                TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    _deleteInterview(interview[
                                        'id']); // Call delete function
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Text(
                        '9:41 AM',
                        style: TextStyle(fontSize: screenHeight * 0.018),
                      ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: loginController().checkuser == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InterviewQuestionsScreen()),
                );
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: screenHeight * 0.03,
              ),
              backgroundColor: AppColors.backgroundColor,
            )
          : null,
    );
  }
}
