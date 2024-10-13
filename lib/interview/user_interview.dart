// ignore_for_file: sort_child_properties_last

import 'dart:async'; // Import for Timer
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../colors/color.dart';
import '../widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:icons_plus/icons_plus.dart';

class UserInterviewsPage extends StatefulWidget {
  final Map<String, dynamic> interview;
  final String InterviewId;

  const UserInterviewsPage({
    required this.InterviewId,
    required this.interview,
  });

  @override
  State<UserInterviewsPage> createState() => _UserInterviewsPageState();
}

class _UserInterviewsPageState extends State<UserInterviewsPage> {
  int currentQuestionIndex = 0;
  int correctAnswersCount = 0;
  List<Map<String, dynamic>> questions = [];
  final TextEditingController _answerController = TextEditingController();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = '';
  Timer? _timer;
  int _remainingTime = 60; // 1-minute timer
  bool _canGoBack = true; // Disable back after answering

  @override
  void initState() {
    super.initState();
    _initializeInterview();
    _initializeSpeech();
    _requestMicrophonePermission();
    _startTimer(); // Start the timer when the screen loads
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    _answerController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
  }

  void _initializeInterview() {
    // Initialize questions list
    if (widget.interview['questions_and_answers'] != null) {
      questions = List<Map<String, dynamic>>.from(
          widget.interview['questions_and_answers']);
    } else {
      print("No questions available.");
    }
  }

  void _initializeSpeech() {
    _speech = stt.SpeechToText();
  }

  Future<void> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Microphone permission is required to use speech input.'),
          ),
        );
      }
    }
  }

  void _startTimer() {
    _remainingTime = 60; // Reset remaining time for each new question
    _timer?.cancel(); // Cancel any previous timer

    // Start a new periodic timer that ticks every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        _submitAnswer(); // Automatically submits the answer when time runs out
      }
    });
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
        body: const Center(
          child: Text('No questions available for this interview.'),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: _capitalizeWords(widget.interview['course_name']) + " Interview",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimer(screenWidth),
                SizedBox(height: screenHeight * 0.02),
                _buildQuestionCounter(screenWidth),
                SizedBox(height: screenHeight * 0.02),
                _buildQuestionText(screenWidth),
                SizedBox(height: screenHeight * 0.02),
                ..._buildAnswerOptions(screenWidth),
                SizedBox(height: screenHeight * 0.02),
                _buildAnswerField(screenWidth, screenHeight),
                if (_voiceInput.isNotEmpty) _buildVoiceInputText(screenWidth),
                SizedBox(height: screenHeight * 0.02),
                _buildNavigationButtons(screenWidth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimer(double screenWidth) {
    return Center(
      child: Text(
        'Time Left: $_remainingTime sec',
        style: TextStyle(
          fontSize: screenWidth * 0.06,
          color: _remainingTime <= 10 ? Colors.red : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuestionCounter(double screenWidth) {
    return Center(
      child: Text(
        'Question ${currentQuestionIndex + 1}/${questions.length}',
        style: TextStyle(fontSize: screenWidth * 0.06),
      ),
    );
  }

  Widget _buildQuestionText(double screenWidth) {
    return Text(
      questions[currentQuestionIndex]['question'] + " ?",
      style: TextStyle(fontSize: screenWidth * 0.045),
    );
  }

  List<Widget> _buildAnswerOptions(double screenWidth) {
    List<String> options = List<String>.from(
      questions[currentQuestionIndex]['answers'] ?? [],
    );

    List<String> optionLabels = ['A', 'B', 'C'];

    return options.asMap().entries.map((entry) {
      int idx = entry.key;
      String option = entry.value;
      String label = optionLabels[idx];

      return Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.005),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200], // Same as input field
            borderRadius:
                BorderRadius.circular(screenWidth * 0.08), // Rounded corners
            border: Border.all(color: Colors.transparent), // No visible border
          ),
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.02,
              horizontal: screenWidth * 0.05),
          child: Row(
            children: [
              Text(
                '$label. ',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
              ),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(fontSize: screenWidth * 0.04),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildAnswerField(double screenWidth, double screenHeight) {
    return TextField(
      controller: _answerController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.08),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02, horizontal: screenWidth * 0.05),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.08),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.08),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        labelText: 'Your Answer',
        suffixIcon: IconButton(
          icon: Icon(
            Icons.mic,
            color: _isListening ? Colors.red : Colors.grey,
          ),
          onPressed: _listen,
        ),
      ),
    );
  }

  Widget _buildVoiceInputText(double screenWidth) {
    return Text(
      'Voice Input: $_voiceInput',
      style: TextStyle(
        fontSize: screenWidth * 0.045,
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildNavigationButtons(double screenWidth) {
    return SizedBox(
      width: double.infinity, // Makes the button full width
      child: ElevatedButton(
        onPressed: _submitAnswer,
        child: Text(
          currentQuestionIndex < questions.length - 1 ? 'Next' : 'Finish',
          style: const TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundColor,
          padding: EdgeInsets.symmetric(
              vertical: screenWidth *
                  0.04), // Adjust vertical padding for button height
        ),
      ),
    );
  }

  // Refactor speech recognition methods for better clarity
  void _listen() async {
    if (!_isListening) {
      // Check microphone permission before initializing speech recognition
      PermissionStatus status = await Permission.microphone.status;
      if (!status.isGranted) {
        status = await Permission.microphone.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Microphone permission is required to use speech input.'),
            ),
          );
          return;
        }
      }

      bool available = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val == 'done' || val == 'notListening') {
            _stopListening(); // Automatically stop when done
          }
        },
        onError: (val) {
          print('onError: $val');
          setState(() {
            _isListening = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Speech recognition error: $val'),
            ),
          );
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _voiceInput = val.recognizedWords;
              _answerController.text = _voiceInput;
            });
          },
          listenFor: Duration(seconds: 30),
          localeId: 'en_US',
          cancelOnError: true,
          partialResults: true, // Enable partial results for real-time feedback
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Speech recognition is not available on this device.'),
          ),
        );
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
  }

  void _submitAnswer() {
    String userAnswer = _answerController.text.trim().toLowerCase();
    String correctAnswer =
        questions[currentQuestionIndex]['correct_answer'].toLowerCase();

    if (userAnswer == correctAnswer) {
      correctAnswersCount++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        _startTimer(); // Restart the timer for the next question
      });
    } else {
      // Show result after finishing the last question
      _timer?.cancel();
      _showResultDialog();
    }

    _answerController.clear();
    _voiceInput = ''; // Clear voice input after submission
  }

  // Removed _prevQuestion() since the "Prev" button is no longer used

  void _showResultDialog() {
    int totalQuestions = questions.length;
    double percentage = (correctAnswersCount / totalQuestions) * 100;
    String resultMessage;
    Icon resultIcon;

    if (percentage >= 80) {
      // Excellent performance
      resultMessage = "Excellent job! You've mastered the material!";
      resultIcon = const Icon(ZondIcons.trophy, color: Colors.orange, size: 60);
    } else if (percentage >= 50) {
      // Good performance
      resultMessage = "Good job! Keep practicing and you'll improve!";
      resultIcon = const Icon(Icons.thumb_up, color: Colors.orange, size: 60);
    } else {
      // Needs improvement
      resultMessage = "Don't worry, keep practicing, and you'll get better!";
      resultIcon =
          const Icon(Icons.sentiment_neutral, color: Colors.orange, size: 60);
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Interview Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              resultIcon, // Display the appropriate icon
              const SizedBox(
                  height: 16), // Add some space between the icon and text
              Text(
                'Percentage: ${percentage.toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 16,
                  color: percentage >= 50 ? Colors.green : Colors.red,
                ),
              ),
              Text(
                resultMessage,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16), // Add space before showing the score
              Text(
                'Correct answers: $correctAnswersCount out of $totalQuestions',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back to the previous screen
              },
              child: const Text('OK'),
            ),
            IconButton(
              icon: Icon(Icons.share, color: Colors.grey),
              onPressed: () {
                Share.share(
                    'I scored ${percentage.toStringAsFixed(2)}% in the quiz with $correctAnswersCount out of $totalQuestions correct answers!');
              },
            ),
          ],
        );
      },
    );
  }

  // Helper method to capitalize each word in a string
  String _capitalizeWords(String str) {
    return str
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }
}
