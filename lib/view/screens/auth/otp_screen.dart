import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as dev;

import '../dashboard/dashboard_Screen.dart';

class SigninOtpPage extends StatefulWidget {
  final String mobileNumber;
  final String? fullName;
  final String? email;
  final String? verificationId;

  const SigninOtpPage({
    super.key,
    required this.mobileNumber,
    this.fullName,
    this.email,
    this.verificationId,
  });

  @override
  State<SigninOtpPage> createState() => _SigninOtpPageState();
}

class _SigninOtpPageState extends State<SigninOtpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  bool _isLoading = false;
  final TextEditingController _otpController = TextEditingController();
  int _otpAttempts = 0;
  bool _isOtpError = false;

  @override
  void initState() {
    super.initState();
    if (widget.verificationId != null && widget.verificationId!.isNotEmpty) {
      _verificationId = widget.verificationId!;
    } else {
      _sendOTP();
    }
  }

  @override
  void dispose() {
    if (mounted) {
      _otpController.dispose();
    }
    super.dispose();
  }

  // New function to handle authentication based on whether user is new or existing
  Future<void> _handleAuthentication(String firebaseToken) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Check if this is a new user (signup) or existing user (signin)
      bool isNewUser = widget.fullName != null && widget.email != null;

      if (isNewUser) {
        // For new users, call the function to store all user details
        await _storeUserData(firebaseToken);
      } else {
        // For existing users, only authenticate with the token
        await _authenticateExistingUser(firebaseToken);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Fix for the _authenticateExistingUser method
  Future<void> _authenticateExistingUser(String firebaseToken) async {
    const apiUrl = 'https://dev.restotag.com/api/user/store-user/';

    try {
      dev.log(
        'Authenticating existing user with token only',
        name: 'SigninOtpPage',
      );

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        // Send empty body since we only need the token
        body: json.encode({}),
      );

      dev.log(
        "User authentication API Response status: ${response.statusCode}",
        name: 'SigninOtpPage',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        dev.log(
          'User authenticated successfully with data: $responseData',
          name: 'SigninOtpPage',
        );

        // Save the firebaseToken to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('firebaseToken', firebaseToken);
        dev.log("Firebase token stored successfully: $firebaseToken");

        // Navigate to HomeScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      } else if (response.statusCode == 404 || response.statusCode == 401) {
        // User doesn't exist or token is invalid
        dev.log("User not found or invalid token", name: 'SigninOtpPage');

        // Show appropriate message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account not found. Please create an account.'),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          _isLoading = false;
        });
      } else if (response.statusCode == 403) {
        dev.log(
          "Token rejected, attempting to refresh token",
          name: 'SigninOtpPage',
        );
        String? newToken = await _refreshFirebaseToken();
        if (newToken != null) {
          await _authenticateExistingUser(newToken); // Retry with new token
        } else {
          throw Exception("Authentication failed: Forbidden");
        }
      } else {
        // Handle other error responses
        String errorMessage = "Authentication failed: ${response.reasonPhrase}";

        if (response.statusCode == 400) {
          errorMessage =
          "Bad Request: The server could not process the request.";
        } else if (response.statusCode == 500) {
          errorMessage = "Server Error: Please try again later.";
        }

        dev.log(errorMessage, name: 'SigninOtpPage');
        throw Exception(errorMessage);
      }
    } catch (e) {
      dev.log("Error authenticating user: $e", name: 'SigninOtpPage', error: e);
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error authenticating user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Update to the _signInWithCredential function to use the new _handleAuthentication function
  // Update the _signInWithCredential method in SigninOtpPage

  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    dev.log('Starting OTP verification...', name: 'SigninOtpPage');
    setState(() {
      _isLoading = true;
    });

    try {
      // Verify OTP with Firebase
      dev.log('Verifying OTP with Firebase...', name: 'SigninOtpPage');
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      dev.log(
        'OTP verification successful. UID: ${userCredential.user?.uid}',
        name: 'SigninOtpPage',
      );

      // Get Firebase token
      dev.log('Getting Firebase token...', name: 'SigninOtpPage');
      String? firebaseToken = await userCredential.user?.getIdToken(true);

      if (firebaseToken == null) {
        dev.log('Failed to get Firebase token', name: 'SigninOtpPage');
        throw Exception('Failed to get Firebase token');
      }

      // Store Firebase token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firebaseToken', firebaseToken);
      dev.log('Firebase token stored successfully', name: 'SigninOtpPage');

      // Check if this is a new user (signup) or existing user (signin)
      bool isNewUser = widget.fullName != null && widget.email != null;

      if (isNewUser) {
        // For new users, call the function to store all user details
        await _storeUserData(firebaseToken);
      } else {
        // For existing users, only authenticate with the token
        await _authenticateExistingUser(firebaseToken);
      }
    } on FirebaseAuthException catch (e) {
      dev.log(
        "OTP verification failed: ${e.code}, ${e.message}",
        name: 'SigninOtpPage',
        error: e,
      );

      setState(() {
        _isLoading = false;
        _isOtpError = true;
      });

      // Clear OTP field on error
      _otpController.clear();

      String errorMessage = 'Invalid OTP. Please try again.';
      if (e.code == 'invalid-verification-code') {
        errorMessage = 'The OTP you entered is incorrect. Please try again.';
      } else if (e.code == 'session-expired') {
        errorMessage = 'OTP session expired. Please request a new OTP.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      dev.log(
        "Error during authentication: $e",
        name: 'SigninOtpPage',
        error: e,
      );
      setState(() {
        _isLoading = false;
        _isOtpError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error during authentication: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String formatPhoneNumber(String phone) {
    if (!phone.startsWith('+')) {
      return '+91$phone'; // Change +91 to the appropriate country code
    }
    return phone;
  }

  Future<void> _sendOTP() async {
    final formattedPhone = formatPhoneNumber(widget.mobileNumber);
    dev.log("Sending OTP to $formattedPhone", name: 'SigninOtpPage');

    setState(() {
      _isLoading = true;
      _isOtpError = false;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          dev.log("Auto verification completed", name: 'SigninOtpPage');
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          dev.log(
            "Verification failed: ${e.code} - ${e.message}",
            name: 'SigninOtpPage',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Verification failed: ${e.message}'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) {
          dev.log(
            "OTP sent. Verification ID: $verificationId",
            name: 'SigninOtpPage',
          );

          setState(() {
            _verificationId = verificationId;
            _isLoading = false;
            _otpAttempts = 0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('OTP sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          dev.log(
            "Auto retrieval timeout. Verification ID: $verificationId",
            name: 'SigninOtpPage',
          );

          setState(() {
            _verificationId = verificationId;
            _isLoading = false;
          });
        },
      );
    } catch (e, stackTrace) {
      dev.log(
        "Error during OTP sending: $e",
        name: 'SigninOtpPage',
        stackTrace: stackTrace,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending OTP: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _storeUserData(String firebaseToken) async {
    dev.log("Storing user data via API...", name: 'SigninOtpPage');

    const apiUrl = 'https://dev.restotag.com/api/user/store-user/';

    try {
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        "full_name": widget.fullName,
        "phone_number": widget.mobileNumber,
        "email": widget.email,
      };

      dev.log(
        "Sending API request with body: $requestBody",
        name: 'SigninOtpPage',
      );

      // Make API call
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken',
        },
        body: json.encode(requestBody),
      );

      dev.log(
        "API Response status: ${response.statusCode}",
        name: 'SigninOtpPage',
      );
      dev.log("API Response body: ${response.body}", name: 'SigninOtpPage');

      // Handling API response based on status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        // API call succeeded, parse the response
        final responseData = json.decode(response.body);

        dev.log("User data stored successfully!", name: 'SigninOtpPage');

        // Save the firebaseToken to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('firebaseToken', firebaseToken);
        dev.log("Firebase token stored successfully: $firebaseToken");

        // Determine user role and navigate

        // Navigate to HomeScreen
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        }
      } else {
        // Handle non-200/201 responses with custom handling for different error codes
        if (response.statusCode == 400) {
          dev.log(
            "Bad Request: The server could not process the request.",
            name: 'SigninOtpPage',
          );
        } else if (response.statusCode == 401) {
          dev.log(
            "Unauthorized: Invalid credentials or token.",
            name: 'SigninOtpPage',
          );
        } else if (response.statusCode == 500) {
          dev.log(
            "Server Error: Please try again later.",
            name: 'SigninOtpPage',
          );
        } else {
          dev.log(
            "Unhandled API Error: ${response.statusCode}",
            name: 'SigninOtpPage',
          );
        }
        throw Exception("API Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      dev.log("Error storing user data: $e", name: 'SigninOtpPage', error: e);
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error storing user data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _verifyOTP(String otp) async {
    dev.log("Verifying OTP: $otp", name: 'SigninOtpPage');

    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-digit OTP'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_verificationId.isEmpty) {
      dev.log(
        "Verification ID is empty. OTP not sent yet.",
        name: 'SigninOtpPage',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for the OTP to be sent'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );

      await _signInWithCredential(credential);
    } catch (e) {
      dev.log(
        "Error during OTP verification: $e",
        name: 'SigninOtpPage',
        error: e,
      );
      setState(() {
        _isOtpError = true;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> _storeAuthenticatedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Store the phone number (without country code) for easy matching
      String phoneNumberWithoutCode = widget.mobileNumber;
      if (phoneNumberWithoutCode.startsWith('+91')) {
        phoneNumberWithoutCode = phoneNumberWithoutCode.substring(3);
      }

      // Add to recent users list
      final recentUsers = prefs.getStringList('recentUsers') ?? [];
      if (!recentUsers.contains(phoneNumberWithoutCode)) {
        recentUsers.add(phoneNumberWithoutCode);
        await prefs.setStringList('recentUsers', recentUsers);
        dev.log(
          'Added user to recent users list: $phoneNumberWithoutCode',
          name: 'SigninOtpPage',
        );
      }
    } catch (e) {
      dev.log(
        'Error storing authenticated user: $e',
        name: 'SigninOtpPage',
        error: e,
      );
    }
  }

  Future<String?> _refreshFirebaseToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return await user.getIdToken(true); // Force refresh
      }
    } catch (e) {
      dev.log("Error refreshing Firebase token: $e", name: 'SigninOtpPage');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
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
                      SizedBox(height: size.height * 0.05),
                      _buildInputField(
                        context,
                        icon: Icons.phone_outlined,
                        hintText: widget.mobileNumber,
                        keyboardType: TextInputType.phone,
                        enabled: false,
                      ),
                      SizedBox(height: size.height * 0.04),
                      Text(
                        'Enter OTP',
                        style: TextStyle(
                          fontSize: size.width * 0.045,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: size.height * 0.015),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: true,
                        obscuringCharacter: '*',
                        animationType: AnimationType.none,
                        controller: _otpController,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(10),
                          fieldHeight: size.width * 0.12,
                          fieldWidth: size.width * 0.12,
                          activeFillColor: Colors.grey.shade100,
                          selectedFillColor: Colors.grey.shade100,
                          inactiveFillColor: Colors.grey.shade100,
                          inactiveColor:
                          _isOtpError
                              ? Colors.red.withOpacity(0.5)
                              : Colors.transparent,
                          selectedColor:
                          _isOtpError ? Colors.red : Colors.orange,
                          activeColor:
                          _isOtpError
                              ? Colors.red.withOpacity(0.5)
                              : Colors.transparent,
                        ),
                        animationDuration: const Duration(milliseconds: 0),
                        backgroundColor: Colors.white,
                        enableActiveFill: true,
                        errorAnimationController: null,
                        onCompleted: (otp) {
                          dev.log(
                            "OTP entry completed: $otp",
                            name: 'SigninOtpPage',
                          );
                          // Auto verify when all digits are entered
                          if (!_isLoading) {
                            _verifyOTP(otp);
                          }
                        },
                        onChanged: (value) {
                          dev.log("OTP changed: $value", name: 'SigninOtpPage');
                          // Clear error state when user starts typing again
                          if (_isOtpError) {
                            setState(() {
                              _isOtpError = false;
                            });
                          }
                        },
                      ),
                      if (_isOtpError)
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Incorrect OTP. Please try again.',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                      SizedBox(height: size.height * 0.015),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the code? ",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: size.width * 0.04,
                            ),
                          ),
                          TextButton(
                            onPressed:
                            _isLoading
                                ? null
                                : () {
                              dev.log(
                                "Resend OTP tapped",
                                name: 'SigninOtpPage',
                              );
                              _sendOTP();
                            },
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                color:
                                _isLoading
                                    ? Colors.grey.shade400
                                    : Colors.orange,
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.04),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                          _isLoading
                              ? null
                              : () {
                            dev.log(
                              "Sign In button pressed with OTP: ${_otpController
                                  .text}",
                              name: 'SigninOtpPage',
                            );
                            _verifyOTP(_otpController.text);
                          },
                          icon: Icon(Icons.arrow_forward),
                          label: Text('VERIFY & SIGN IN'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
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
                              "Navigating to Create Account screen",
                              name: 'SigninOtpPage',
                            );
                            Navigator.pop(context);
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
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context, {
    required IconData icon,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    final size = MediaQuery
        .of(context)
        .size;
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
            child: TextField(
              keyboardType: keyboardType,
              enabled: enabled,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}