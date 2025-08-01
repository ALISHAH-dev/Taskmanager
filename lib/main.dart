
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmanager/Homepage.dart';
import 'package:taskmanager/ONboarding.dart';

import 'package:taskmanager/Themeprovider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Task Manager',
          theme: themeProvider.themeData,
          home: OnboardingScreen1()
        );
      },
    );
  }
}
