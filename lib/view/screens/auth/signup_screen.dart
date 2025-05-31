import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:restotag_customer_app/utils/AppColors.dart';
import 'package:restotag_customer_app/view/screens/auth/login_screen.dart';

import '../dashboard/dashboard_Screen.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
            Hero(
              tag: 'title',
              child: Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'name',
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.textfieldBg,

                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // corner radius
                      borderSide: BorderSide.none, // no border line
                    ),
                    hintText: 'Full Name',
                    prefixIcon: Icon(Icons.person_2_outlined),
                  ),
                  keyboardType: TextInputType.name,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'email',
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: AppColors.textfieldBg,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // corner radius
                      borderSide: BorderSide.none, // no border line
                    ),
                    prefixIcon: Icon(Icons.email_outlined)
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'number',
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.textfieldBg,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6), // corner radius
                      borderSide: BorderSide.none, // no border line
                    ),
                    hintText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone_android_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
            Spacer(),
            Hero(
              tag: 'main_btn',
              child: FilledButton.icon(
                onPressed: () => Get.off(const OtpScreen()),
                label: Text('CREATE ACCOUNT'),
                icon: Icon(Icons.arrow_forward),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(AppColors.primary),
                  padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
                ),
              ),
            ),
            SizedBox(height: 16),
            Hero(
              tag: 'scnd_btn',
              child: TextButton(onPressed: () {
                Get.to(DashboardScreen());
              }, child: Text('SIGN IN')),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
