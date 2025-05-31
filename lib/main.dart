import 'dart:developer' as dev;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restotag_customer_app/view/screens/auth/login_screen.dart';
import 'package:restotag_customer_app/view/screens/dashboard/dashboard_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Retrieve stored data from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final firebaseToken = prefs.getString('firebaseToken');

  runApp(MyApp(firebaseToken: firebaseToken));
}

class MyApp extends StatelessWidget {
  final String? firebaseToken;

  const MyApp({super.key, required this.firebaseToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        onInitializationComplete: () {
          // This callback will be called when splash screen is done
          return _buildHome();
        },
      ),
    );
  }

  Widget _buildHome() {
    // If no token is stored, show sign in screen
    if (firebaseToken == null) {
      dev.log('No stored token found, showing sign in screen', name: 'MyApp');
      return SignInPage();
    }else{
      return HomeScreen();
    }
  }
}

class FutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, AsyncSnapshot<T> snapshot)
  builder;

  const FutureBuilder({super.key, required this.future, required this.builder});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(future: future, builder: builder);
  }
}