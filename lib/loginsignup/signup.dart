// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../colors/color.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SizedBox(height: 100.0),
        Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Create an Account',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 30.0),
      ],
    );
  }

  Widget _buildTextField({
    required String labelText,
    required bool obscureText,
    required String? Function(String?) validator,
    required TextEditingController controller,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    IconData? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFFAFAAE6)), // Blue color
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFAFAAE6)), // Blue color
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFAFAAE6)), // Light blue color
        ),
        errorBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Colors.red), // Red color for error border
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: Color(0xFFAFAAE6))
            : null,
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildSignUpButton(double width) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            // Sign up user with Firebase Auth
            UserCredential userCredential =
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );

            // Get user information
            User? user = userCredential.user;
            if (user != null) {
              // Store additional user information in Firestore
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .set({
                "username": _usernameController.text,
                "email": _emailController.text,
                "password": _passwordController.text,
                "createdId": DateTime.now(),
                "uPhone": _phoneController.text,
                "profileImage": "",
                // 'active': 0,
                "userId": user.uid,
                "checkuser": "user",
                "aboutme": " "
              });

              // Successfully signed up
              print("Sign Up Successful");
              // Optionally navigate to a different screen
            }
          } on FirebaseAuthException catch (e) {
            // Handle Firebase sign-up errors here
            print(e.message);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? "Sign up failed")),
            );
          }
        }
      },
      child: const Text(
        'Sign Up',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: width * 0.23, vertical: 20.0),
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }

  Widget _buildSignUpForm(double width) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTextField(
            labelText: 'Enter your username',
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
            controller: _usernameController,
            prefixIcon: Icons.person,
          ),
          SizedBox(height: 20.0),
          _buildTextField(
            labelText: 'Enter your email',
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // Regex for basic email validation
              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value);
              if (!emailValid) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            controller: _emailController,
            prefixIcon: Icons.email,
          ),
          SizedBox(height: 20.0),
          _buildTextField(
            labelText: 'Enter your phone number',
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              // Regex for basic phone number validation
              bool phoneValid = RegExp(r"^\d{10}$").hasMatch(value);
              if (!phoneValid) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
            controller: _phoneController,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.phone,
          ),
          SizedBox(height: 20.0),
          _buildTextField(
            labelText: 'Enter your password',
            obscureText: !_passwordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              // Password validation regex
              bool passwordValid = RegExp(
                r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$',
              ).hasMatch(value);
              if (!passwordValid) {
                return 'Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one special character, and one number';
              }
              return null;
            },
            controller: _passwordController,
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
            prefixIcon: Icons.lock,
          ),
          SizedBox(height: 20.0),
          _buildTextField(
            labelText: 'Confirm your password',
            obscureText: !_confirmPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            controller: _confirmPasswordController,
            suffixIcon: IconButton(
              icon: Icon(
                _confirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _confirmPasswordVisible = !_confirmPasswordVisible;
                });
              },
            ),
            prefixIcon: Icons.lock,
          ),
          SizedBox(height: 20.0),
          _buildSignUpButton(width),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?",
                  style: TextStyle(color: Color(0xFFAFAAE6))),
              TextButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: AppColors.backgroundColor),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(0.0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.backgroundColor,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: _buildSignUpForm(size.width),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
