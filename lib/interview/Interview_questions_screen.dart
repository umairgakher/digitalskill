// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_declarations, prefer_const_constructors, unnecessary_to_list_in_spreads, sort_child_properties_last, library_private_types_in_public_api, use_key_in_widget_constructors, file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../colors/color.dart';

import '../user/Userdashboard/interview.dart';
import '../widget/appbar.dart';
// Ensure this import matches your project's path

class InterviewQuestionsScreen extends StatefulWidget {
  @override
  _InterviewQuestionsScreenState createState() =>
      _InterviewQuestionsScreenState();
}

class _InterviewQuestionsScreenState extends State<InterviewQuestionsScreen> {
  final _courseNameController = TextEditingController();
  final _descriptionController =
      TextEditingController(); // Controller for the description field
  final List<Map<String, TextEditingController>> _questionsAndAnswers = [
    {
      'question': TextEditingController(),
      'answer1': TextEditingController(),
      'answer2': TextEditingController(),
      'answer3': TextEditingController(),
      'correctAnswer': TextEditingController(),
    }
  ];

  void _addQuestionAnswerField() {
    setState(() {
      _questionsAndAnswers.add({
        'question': TextEditingController(),
        'answer1': TextEditingController(),
        'answer2': TextEditingController(),
        'answer3': TextEditingController(),
        'correctAnswer': TextEditingController(),
      });
    });
  }

  void _removeQuestionAnswerField(int index) {
    if (_questionsAndAnswers.length > 1) {
      setState(() {
        _questionsAndAnswers.removeAt(index);
      });
    }
  }

  Future<void> _saveData() async {
    final courseName = _courseNameController.text;
    final description = _descriptionController.text; // Get the description text
    final questionsAndAnswersData = _questionsAndAnswers.map((item) {
      return {
        'question': item['question']?.text ?? '',
        'answers': [
          item['answer1']?.text ?? '',
          item['answer2']?.text ?? '',
          item['answer3']?.text ?? '',
        ],
        'correct_answer': item['correctAnswer']?.text ?? '',
      };
    }).toList();

    // Create a reference to the Firestore collection
    final firestore = FirebaseFirestore.instance;
    final courseRef = firestore.collection('interviews').doc();

    try {
      // Save the course data
      await courseRef.set({
        'course_name': courseName,
        'description': description,
        'questions_and_answers': questionsAndAnswersData,
      });

      print('Data saved successfully!');

      // Clear fields
      _courseNameController.clear();
      _descriptionController.clear();
      _questionsAndAnswers.forEach((item) {
        item['question']?.dispose();
        item['answer1']?.dispose();
        item['answer2']?.dispose();
        item['answer3']?.dispose();
        item['correctAnswer']?.dispose();
      });

      setState(() {
        _questionsAndAnswers.clear();
        _questionsAndAnswers.add({
          'question': TextEditingController(),
          'answer1': TextEditingController(),
          'answer2': TextEditingController(),
          'answer3': TextEditingController(),
          'correctAnswer': TextEditingController(),
        });
      });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => InterviewScreen()));
    } catch (e) {
      print('Failed to save data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final padding = 16.0;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Interview Questions",
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Course Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildInputField(
                controller: _courseNameController,
                hintText: 'Enter the course name',
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              _buildInputField(
                controller: _descriptionController,
                hintText: 'Enter the description',
                maxLines: 3, // Allowing multi-line input for the description
              ),
              SizedBox(height: 20),
              Text(
                'Questions and Answers',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              ..._questionsAndAnswers.asMap().entries.map((entry) {
                int index = entry.key + 1; // Index starts from 1
                var item = entry.value;
                return Container(
                  padding: EdgeInsets.all(padding),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_questionsAndAnswers.length > 1)
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.cancel,
                                color: AppColors.backgroundColor),
                            onPressed: () =>
                                _removeQuestionAnswerField(entry.key),
                          ),
                        ),
                      Text(
                        'Question $index',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInputField(
                        controller: item['question']!,
                        hintText: 'Enter the question',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Answer 1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInputField(
                        controller: item['answer1']!,
                        hintText: 'Enter the first answer',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Answer 2',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInputField(
                        controller: item['answer2']!,
                        hintText: 'Enter the second answer',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Answer 3',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInputField(
                        controller: item['answer3']!,
                        hintText: 'Enter the third answer',
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Correct Answer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      _buildInputField(
                        controller: item['correctAnswer']!,
                        hintText: 'Enter the correct answer',
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveData,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.backgroundColor,
                    minimumSize: Size(
                        width * 0.8, height * 0.07), // Responsive button size
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuestionAnswerField,
        backgroundColor: AppColors.backgroundColor,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildInputField(
      {required TextEditingController controller,
      required String hintText,
      int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.red),
        ),
        hintText: hintText,
      ),
    );
  }
}
