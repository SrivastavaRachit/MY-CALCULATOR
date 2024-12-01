import 'dart:async';
import 'package:flutter/material.dart';

import 'calculator_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    //Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    //Define Animation
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );

    // start the animation
    _controller.forward();

    //Navigation to Calculate after 3 seconds
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const CalculatorScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? const Color(0xFF151B2F) : Colors.white;
    final logoImage =
        isDarkMode ? 'assets/logo_dark.png' : 'assets/logo_white.png';
    final titleColor = isDarkMode ? Colors.white : Colors.black54;
    final subtitleColor = isDarkMode ? Colors.grey : Colors.black54;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  logoImage,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Text(
                'Calculator',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            FadeTransition(
              opacity: _textFadeAnimation,
              child: Text(
                'A fully functional app built\nusing flutter.\nYour Mini Project',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: subtitleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
