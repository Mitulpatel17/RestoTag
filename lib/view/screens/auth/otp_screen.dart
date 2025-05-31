import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:restotag_customer_app/view/screens/auth/signup_screen.dart';

import '../../../utils/AppColors.dart';
import '../dashboard/dashboard_Screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36,horizontal: 25),       child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(),
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary, // Replace with your desired color
              ),
              textAlign: TextAlign.center,


            ),
            Text('Verify your phone number', textAlign: TextAlign.center),
            Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  color:  AppColors.background, // Light background
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                child: TextField(
                  controller: TextEditingController(text: '9427648882'),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey),
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: const EdgeInsets.all(16),

                    enabled: false,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: OtpTextField(
                onCodeChanged: (value) {},
                onSubmit: (value) {},
                numberOfFields: 6,
                keyboardType: TextInputType.number,
                showFieldAsBox: true,
                borderColor: AppColors.primary,
                autoFocus: true,
                focusedBorderColor: AppColors.primary,
                enabledBorderColor: Theme.of(context).focusColor,
              ),
            ),
            SizedBox(height: 12),
            TextButton(onPressed: () {}, child: Text('Resend OTP',
                style: TextStyle(
                  fontSize: 16, // adjust as needed
                  color: Colors.grey, // or any other color
                ))),
            Spacer(),
            FilledButton.icon(
              onPressed: () {
                Get.to(DashboardScreen());
              },
              label: Text('SIGN IN'),
              icon: Icon(Icons.arrow_forward),
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                backgroundColor: MaterialStateProperty.all(AppColors.primary)

              ),
            ),
            SizedBox(height: 16),
            TextButton(onPressed: () => Get.off(const SignupScreen()), child: Text('CREATE ACCOUNT',
                style: TextStyle(
                  fontSize: 16, // adjust as needed
                  color: AppColors.GreyDark, // or any other color
                ))),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
