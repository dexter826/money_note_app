import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation
            SizedBox(
              width: 250,
              height: 250,
              child: Lottie.asset(
                'assets/animations/money_animation.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller.forward();
                },
              ),
            ),
            // App name
            const Text(
              'Money Note',
              style: TextStyle(
                color: kAccentColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Quản lý chi tiêu thông minh',
              style: TextStyle(color: kTextLightColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
