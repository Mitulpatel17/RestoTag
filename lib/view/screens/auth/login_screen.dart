import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restotag_customer_app/view/screens/auth/otp_screen.dart';
import 'package:restotag_customer_app/view/screens/auth/signup_screen.dart';

import '../../../utils/AppColors.dart';
import '../dashboard/dashboard_Screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'Verify your phone number',
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color:  AppColors.background, // Light background
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey),
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(color: Colors.grey),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
            )
            ,
            Spacer(),
            FilledButton.icon(
              onPressed: () => Get.off(const OtpScreen()),
              label: Text('SEND OTP'),
              icon: Icon(Icons.arrow_forward),
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                backgroundColor: MaterialStateProperty.all(AppColors.primary),
              )
              ,


            ),
            SizedBox(height: 16),
            TextButton(onPressed: () => Get.off(const SignupScreen()),
             child: Text('CREATE ACCOUNT')),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
