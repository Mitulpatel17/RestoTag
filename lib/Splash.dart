import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  final Widget? nextScreen;
  final Widget Function() onInitializationComplete;

  const SplashScreen({
    Key? key,
    this.nextScreen,
    required this.onInitializationComplete,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  // Define orange color
  final Color orangeColor = Colors.orange;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();

    Timer(const Duration(seconds: 3), () {
      // Use the onInitializationComplete callback to get the next screen
      final nextScreen = widget.onInitializationComplete();
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => nextScreen));
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed to white background
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(
                    'assets/branding/resto_tag.jpg',
                    width: 150,
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                if (_animationController.value > 0.7)
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        orangeColor.withOpacity(
                          _opacityAnimation.value,
                        ), // Changed to orange
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}