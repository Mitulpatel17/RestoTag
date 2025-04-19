import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:restotag_customer_app/view/base/resizable_scrollview.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

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
                enabled: false,
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Enter OTP:'),
                OtpTextField(
                  onCodeChanged: (value) {},
                  onSubmit: (value) {},
                  numberOfFields: 4,
                  keyboardType: TextInputType.number,
                  showFieldAsBox: true,
                  borderColor: Theme.of(context).primaryColor,
                  autoFocus: true,
                  enabledBorderColor: Theme.of(context).focusColor,
                ),
              ],
            ),
            SizedBox(height: 12),
            TextButton(onPressed: () {}, child: Text('Resend OTP')),
            Spacer(),
            Hero(
              tag: 'main_btn',
              child: FilledButton.icon(
                onPressed: () {},
                label: Text('SIGN IN'),
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
      ),
    );
  }
}
