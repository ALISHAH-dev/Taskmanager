import 'dart:async';
import 'package:flutter/material.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:taskmanager/ONboarding.dart';


class SplashScreen1 extends StatefulWidget {
  @override
  State<SplashScreen1> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen1> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen1()), // placeholder
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
     child:  RippleAnimation(
        child: CircleAvatar(
          minRadius: 75,
          maxRadius: 75,
          backgroundImage: AssetImage("assets/task.png"),
        ),
        color: Colors.deepOrange,
        delay: const Duration(milliseconds: 300),
        repeat: true,
        minRadius: 75,
        maxRadius: 140,
        ripplesCount: 6,
        duration: const Duration(milliseconds: 6 * 300),
      ),
      )
    );
  }
}