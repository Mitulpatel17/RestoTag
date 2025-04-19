import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restotag_customer_app/view/base/resizable_scrollview.dart';
import 'package:restotag_customer_app/view/screens/auth/otp_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ResizableScrollView(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        padding: EdgeInsets.all(36),
        children: [
          Spacer(),
          Hero(
            tag: 'title',
            child: Text(
              'Sign In',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Hero(
            tag: 'subtitle',
            child: Text(
              'Verify your phone number',
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Hero(
            tag: 'number',
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Mobile Number',
                icon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
          Spacer(),
          Hero(
            tag: 'main_btn',
            child: FilledButton.icon(
              onPressed: () => Get.off(const OtpScreen()),
              label: Text('SEND OTP'),
              icon: Icon(Icons.arrow_forward),
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(18)),
              ),
            ),
          ),
          SizedBox(height: 16),
          Hero(
            tag: 'scnd_btn',
            child: TextButton(onPressed: () {}, child: Text('CREATE ACCOUNT')),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
