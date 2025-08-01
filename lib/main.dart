// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:taskmanager/Homepage.dart';
// import 'package:taskmanager/Splash.dart';
// import 'package:taskmanager/Themeprovider.dart';
//
// void main() {
// //     // ProviderScope(child: KindSparkApp())
//       runApp(
//         ChangeNotifierProvider(
//           create: (context) => ThemeProvider(),
//           child: const MyApp(),
//         ),
//       );
//   }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ThemeProvider>(
//       builder: (context, themeProvider, _) {
//         return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Task Manager',
//             //  themeMode: themeProvider.themeMode,
//             theme: ThemeData(
//               brightness: Brightness.light,
//               primarySwatch: Colors.deepPurple,
//             ),
//             darkTheme: ThemeData(
//               brightness: Brightness.dark,
//               primarySwatch: Colors.deepPurple,
//             ),
//             home: SplashScreen1() // ✅ Make sure KindSparkApp exists
//         );
//       });
//   }
// }
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