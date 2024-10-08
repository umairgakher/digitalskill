// ignore_for_file: sort_child_properties_last, prefer_const_constructors, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../colors/color.dart';
import '../widget/appbar.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendPasswordResetEmail() async {
    final email = _emailController.text.trim();
    if (email.isNotEmpty) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent!')),
        );
        Navigator.of(context).pop(); // Go back to login screen
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'user-not-found':
            errorMessage = 'No user found with that email.';
            break;
          default:
            errorMessage =
                'Failed to send password reset email. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
    }
  }

  Widget _buildTextField({
    required String labelText,
    required IconData prefixIcon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool obscureText = false,
    IconButton? suffixIcon,
  }) {
    final width = MediaQuery.of(context).size.width;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon, color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(width * 0.08),
          borderSide: BorderSide(color: AppColors.backgroundColor),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.02,
            horizontal: width * 0.05),
      ),
      style: TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Reset Password",
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter your email address to receive a password reset link.',
                    style: TextStyle(
                        fontSize: width * 0.045,
                        color: AppColors.backgroundColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: height * 0.02),
                  _buildTextField(
                    labelText: 'Email',
                    controller: _emailController,
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _sendPasswordResetEmail();
                        _emailController
                            .clear(); // Clear the email field after sending the email reset link
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Password reset email sent!')),
                        );
                      }
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.045),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.2, vertical: height * 0.02),
                      backgroundColor: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * 0.05),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
