import 'package:flutter/material.dart';
import 'dart:async';
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

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainHomeScreenDashBoard()),
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
                /// TOP TEXT
                const Text(
                  "Your Healthy Life Is\nOur Priority",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 25),

                /// FOOT IMAGE (ALREADY ADDED BY YOU)
                Image.asset("assets/images/jin_reflexo.png", width: w * 0.45),

                const SizedBox(height: 25),

                /// YELLOW STRIP
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEB3B),
                    borderRadius: BorderRadius.circular(25),
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

                const SizedBox(height: 30),

                /// GREEN TEXT
                const Text(
                  "Perfect Diagnosis &\nFast Results",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.lightGreenAccent,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 35),

                /// BOTTOM TEXT
                const Text(
                  "Jain Chumbak  -  JIN Health Care\nSince 1989",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
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