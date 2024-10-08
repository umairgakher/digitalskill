// ignore_for_file: use_key_in_widget_constructors, prefer_final_fields, prefer_const_constructors, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, sort_child_properties_last, use_build_context_synchronously

import '../../colors/color.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widget/appbar.dart';

class AdminEditInterviewPage extends StatefulWidget {
  final Map<String, dynamic> interview;
  final String interviewId;

  const AdminEditInterviewPage({
    required this.interviewId,
    required this.interview,
  });

  @override
  State<AdminEditInterviewPage> createState() => _AdminEditInterviewPageState();
}

class _AdminEditInterviewPageState extends State<AdminEditInterviewPage> {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> questions = [];
  TextEditingController _questionController = TextEditingController();
  List<TextEditingController> _answerControllers = [];
  TextEditingController _correctAnswerController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Safely initialize questions list
    if (widget.interview['questions_and_answers'] != null) {
      questions = List<Map<String, dynamic>>.from(
          widget.interview['questions_and_answers']);
    } else {
      // ignore: avoid_print
      print("No questions available.");
    }

    // Initialize the controllers for the first question
    _initializeQuestionControllers(currentQuestionIndex);
  }

  void _initializeQuestionControllers(int index) {
    _questionController.text = questions[index]['question'];
    _answerControllers = List.generate(
      3, // Assuming 3 options per question
      (i) => TextEditingController(text: questions[index]['answers'][i]),
    );
    _correctAnswerController.text = questions[index]['correct_answer'];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.interview["course_name"] ?? 'Interview'),
        ),
        body: Center(
          child: Text('No questions available for this interview.'),
        ),
      );
    }

    String _capitalizeWords(String input) {
      return input
          .split(' ')
          .map(
              (word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: _capitalizeWords(widget.interview['course_name']) + " Interview",
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Question ${currentQuestionIndex + 1}/${questions.length}',
                  style: TextStyle(fontSize: screenWidth * 0.06),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              _buildQuestionField(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildAnswerFields(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildCorrectAnswerField(screenWidth),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (questions.length > 1 && currentQuestionIndex > 0)
                    ElevatedButton(
                      onPressed: _prevQuestion,
                      child: Text(
                        'Prev',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.backgroundColor),
                    ),
                  ElevatedButton(
                    onPressed: currentQuestionIndex < questions.length - 1
                        ? _saveUpdates
                        : _updateInterviewInDatabase,
                    child: Text(
                      currentQuestionIndex < questions.length - 1
                          ? 'Next'
                          : 'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.backgroundColor),
                  ),
                  if (questions.length > 1)
                    ElevatedButton(
                      onPressed: _deleteQuestion,
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.backgroundColor),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionField(double screenWidth) {
    return TextField(
      controller: _questionController,
      decoration: InputDecoration(
        labelText: 'Edit Question',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.08),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: screenWidth * 0.05),
      ),
    );
  }

  Widget _buildAnswerFields(double screenWidth) {
    return Column(
      children: List.generate(_answerControllers.length, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
          child: TextField(
            controller: _answerControllers[index],
            decoration: InputDecoration(
              labelText: 'Edit Answer ${index + 1}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.08),
                borderSide: BorderSide(color: AppColors.backgroundColor),
              ),
              contentPadding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: screenWidth * 0.05),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCorrectAnswerField(double screenWidth) {
    return TextField(
      controller: _correctAnswerController,
      decoration: InputDecoration(
        labelText: 'Edit Correct Answer',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.08),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: screenWidth * 0.05),
      ),
    );
  }

  void _saveUpdates() {
    setState(() {
      // Save the updated question and answers
      questions[currentQuestionIndex]['question'] = _questionController.text;
      questions[currentQuestionIndex]['answers'] =
          _answerControllers.map((controller) => controller.text).toList();
      questions[currentQuestionIndex]['correct_answer'] =
          _correctAnswerController.text;

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        _initializeQuestionControllers(currentQuestionIndex);
      } else {
        _updateInterviewInDatabase();
      }
    });
  }

  void _prevQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        _initializeQuestionControllers(currentQuestionIndex);
      }
    });
  }

  void _deleteQuestion() {
    setState(() {
      // Remove the current question from the list
      questions.removeAt(currentQuestionIndex);

      if (questions.isEmpty) {
        // Navigate back if there are no questions left
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No questions left. Navigating back.')),
        );
        Navigator.of(context).pop();
      } else {
        // Move to the previous question or the next one
        if (currentQuestionIndex >= questions.length) {
          currentQuestionIndex = questions.length - 1;
        }
        _initializeQuestionControllers(currentQuestionIndex);
      }
    });
  }

  void _updateInterviewInDatabase() {
    FirebaseFirestore.instance
        .collection('interviews')
        .doc(widget.interviewId)
        .update({
      'questions_and_answers': questions,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Interview updated successfully!')),
      );
      Navigator.of(context).pop();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update interview: $error')),
      );
    });
  }
}
