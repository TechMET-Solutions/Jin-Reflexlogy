import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:jin_reflex_new/screens/main_home_dashoabrd_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoRotation;
  late Animation<double> _firstTextOpacity;
  late Animation<double> _secondTextOpacity;
  late Animation<double> _thirdTextOpacity;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    // Fade animation for entire screen
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Scale animation for main container
    _scaleAnimation = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Logo rotation animation
    _logoRotation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.3, curve: Curves.easeInOut),
      ),
    );

    // Text animations with delays
    _firstTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.5, curve: Curves.easeIn),
      ),
    );

    _secondTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeIn),
      ),
    );

    _thirdTextOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 0.9, curve: Curves.easeIn),
      ),
    );

    // Slide animation for bottom text
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
                  MainHomeScreenDashBoard(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
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
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 4, 66),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // TOP TEXT with fade
                FadeTransition(
                  opacity: _firstTextOpacity,
                  child: const Text(
                    "Your Healthy Life Is\nOur Priority",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // LOGO with rotation and pulse
                Image.asset("assets/images/image 4.png", width: w * 0.45),

                const SizedBox(height: 25),

                // YELLOW STRIP with fade
                FadeTransition(
                  opacity: _secondTextOpacity,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEB3B),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4B2E83),
                        ),
                        children: [
                          TextSpan(
                            text: "J",
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(text: "ustified - "),
                          TextSpan(
                            text: "I",
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(text: "ntegrated - "),
                          TextSpan(
                            text: "N",
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(text: "atural "),
                          TextSpan(
                            text: "Reflexology",
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // GREEN TEXT with fade
                FadeTransition(
                  opacity: _thirdTextOpacity,
                  child: const Text(
                    "Perfect Diagnosis &\nFast Results",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.lightGreenAccent,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // BOTTOM TEXT with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: const Text(
                    "Jain Chumbak  -  JIN Health Care\nSince 1989",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),

                // Loading indicator
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _thirdTextOpacity,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.yellow.withOpacity(0.8),
                      ),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
