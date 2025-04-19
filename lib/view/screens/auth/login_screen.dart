import 'package:flutter/material.dart';
import 'package:restotag_customer_app/view/base/resizable_scrollview.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResizableScrollView(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        padding: EdgeInsets.all(36),
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
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Mobile Number',
              icon: Icon(Icons.phone_outlined),
            ),
            keyboardType: TextInputType.phone,
          ),
          Spacer(),
          FilledButton.icon(
            onPressed: () {},
            label: Text('SEND OTP'),
            icon: Icon(Icons.arrow_forward),
          ),
          TextButton(onPressed: () {}, child: Text('CREATE ACCOUNT')),
          Spacer(),
        ],
      ),
    );
  }
}
