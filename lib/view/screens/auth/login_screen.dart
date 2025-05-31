import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:restotag_customer_app/view/screens/auth/signup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboard_Screen.dart';
import 'otp_screen.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController mobileNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  /// Validate mobile number format (10 digits only)
  bool isValidMobileNumber(String mobileNumber) {
    return mobileNumber.length == 10 &&
        RegExp(r'^[0-9]+$').hasMatch(mobileNumber);
  }

  /// Save user login state in SharedPreferences
  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true); // Save login state
  }

  /// Send OTP using Firebase Auth
  void _sendOtp(BuildContext context) async {
    final mobileNumber = mobileNumberController.text.trim();

    if (mobileNumber.isEmpty || !isValidMobileNumber(mobileNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 10-digit mobile number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final phone = '+91$mobileNumber';
    log("Initiating OTP request for: $phone");

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),

        // Auto-verification trigger
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            log("🔒 Auto verification triggered. Signing in user...");
            UserCredential userCredential = await _auth.signInWithCredential(
              credential,
            );
            String? firebaseToken = await userCredential.user?.getIdToken();
            log("✅ Auto verification success. Firebase token: $firebaseToken");

            // Save the login state after successful login
            await _saveLoginState();

            // Navigate to the home screen or next step
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          } catch (e) {
            log("❌ Auto verification error: $e");
            // Fluttertoast.showToast(
            //   msg: 'Auto verification failed. Try manually.',
            // );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Auto verification failed. Try manually.'),
                duration: Duration(seconds: 2),
              ),
            );

          } finally {
            setState(() {
              _isLoading = false;
            });
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          log("❌ Firebase verification failed: ${e.message}");
          // Fluttertoast.showToast(msg: 'Verification failed: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.message}'),
              duration: Duration(seconds: 2),
            ),
          );

          setState(() {
            _isLoading = false;
          });
        },

        codeSent: (String verificationId, int? resendToken) {
          log("📩 OTP sent. verificationId: $verificationId");
          // Fluttertoast.showToast(msg: 'OTP sent successfully!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('OTP Sent Successfully!'),
              duration: Duration(seconds: 2),
            ),
          );

          setState(() {
            _isLoading = false;
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SigninOtpPage(
                mobileNumber: mobileNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          log(
            "⏱️ OTP auto-retrieval timed out. verificationId: $verificationId",
          );
          setState(() {
            _isLoading = false;
          });
        },
      );
    } catch (e) {
      log("❌ Error sending OTP: $e");
      // Fluttertoast.showToast(msg: 'Error sending OTP. Please try again.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending OTP. Please try again'),
          duration: Duration(seconds: 2),
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.05),
                  Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: size.width * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Center(
                    child: Text(
                      'Verify your\nphone number',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: size.width * 0.045,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),

                  // Mobile Number Input Field
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.grey),
                        SizedBox(width: size.width * 0.02),
                        Expanded(
                          child: TextField(
                            controller: mobileNumberController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mobile Number',
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Send OTP Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : () => _sendOtp(context),
                      icon:
                      _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.arrow_forward),
                      label: Text(_isLoading ? 'SENDING...' : 'SEND OTP'),
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

                  // Create Account Navigation
                  Center(
                    child: TextButton(
                      onPressed:
                      _isLoading
                          ? null
                          : () {
                        log("Navigating to Create Account Page");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => const CreateAccountPage(),
                          ),
                        );
                      },
                      child: Text(
                        'CREATE ACCOUNT',
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
    );
  }
}