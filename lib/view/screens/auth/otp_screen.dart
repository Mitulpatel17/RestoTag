import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

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
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text('Verify your phone number', textAlign: TextAlign.center),
            Spacer(),
            TextField(
              controller: TextEditingController(text: '9427648882'),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: 'Mobile Number',
                icon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
              enabled: false,
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
            FilledButton.icon(
              onPressed: () {},
              label: Text('SIGN IN'),
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
