import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as dev;

import 'otp_screen.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.08,
                vertical: size.height * 0.05,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.05),
                    Center(
                      child: Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: size.width * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    _buildNameField(context),
                    SizedBox(height: size.height * 0.025),
                    _buildEmailField(context),
                    SizedBox(height: size.height * 0.025),
                    _buildMobileNumberField(context),
                    SizedBox(height: size.height * 0.05),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          dev.log(
                            'Create Account button pressed',
                            name: 'CreateAccountPage',
                          );
                          _validateAndProceed(context);
                        },
                        icon: Icon(Icons.arrow_forward),
                        label: Text('CREATE ACCOUNT'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: size.height * 0.02,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          textStyle: TextStyle(
                            fontSize: size.width * 0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          dev.log(
                            'Sign In button pressed',
                            name: 'CreateAccountPage',
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * 0.04,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return _buildField(
      icon: Icons.person_outline,
      hintText: 'Full Name',
      controller: nameController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        if (value.trim().length < 3) {
          return 'Name must be at least 3 characters';
        }
        return null;
      },
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return _buildField(
      icon: Icons.email_outlined,
      hintText: 'Email',
      controller: emailController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildMobileNumberField(BuildContext context) {
    return _buildField(
      icon: Icons.phone_outlined,
      hintText: 'Mobile Number (10 digits)',
      controller: mobileController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your mobile number';
        }
        if (value.length != 10) {
          return 'Mobile number must be 10 digits';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      maxLength: 10,
    );
  }

  Widget _buildField({
    required IconData icon,
    required String hintText,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
                counterText: '',
              ),
              validator: validator,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateAndProceed(BuildContext context) async {
    FocusScope.of(context).unfocus();
    dev.log('Starting form validation...', name: 'CreateAccountPage');

    if (_formKey.currentState!.validate()) {
      dev.log(
        'Form validation successful. Proceeding to store user details...',
        name: 'CreateAccountPage',
      );

      // Store user details in SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        dev.log(
          'SharedPreferences instance obtained',
          name: 'CreateAccountPage',
        );

        final fullName = nameController.text.trim();
        final email = emailController.text.trim();
        final mobile = mobileController.text.trim();

        dev.log(
          'Storing user details:\nFull Name: $fullName\nEmail: $email\nMobile: $mobile',
          name: 'CreateAccountPage',
        );

        await prefs.setString('fullName', fullName);
        await prefs.setString('email', email);
        await prefs.setString('mobile', mobile);

        dev.log(
          'User details stored successfully in SharedPreferences',
          name: 'CreateAccountPage',
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sending OTP to your mobile number...'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 1),
          ),
        );

        final formattedNumber = '+91$mobile';
        dev.log(
          'Navigating to OTP screen with formatted number: $formattedNumber',
          name: 'CreateAccountPage',
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => SigninOtpPage(
              mobileNumber: formattedNumber,
              fullName: fullName,
              email: email,
            ),
          ),
        );
      } catch (e) {
        dev.log(
          'Error storing user details: $e',
          name: 'CreateAccountPage',
          error: e,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      dev.log(
        'Form validation failed. Please check the entered details.',
        name: 'CreateAccountPage',
      );
    }
  }
}