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
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Mobile Number',
                icon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            Spacer(),
            FilledButton.icon(
              onPressed: () => Get.off(const OtpScreen()),
              label: Text('SEND OTP'),
              icon: Icon(Icons.arrow_forward),
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
              ),
            ),
            SizedBox(height: 16),
            TextButton(onPressed: () {}, child: Text('CREATE ACCOUNT')),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
