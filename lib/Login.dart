import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taskmanager/Homepage.dart';
import 'package:taskmanager/Signup.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Gradient Circle
            Container(
              height: size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE6E6FA), Color(0xFFD8B4FE)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.elliptical(300, 100),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Login Text
            const Text(
              'Login',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return SignupScreen();
                    }));
                  },
                  child: const Text(
                    'sign up',
                    style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Phone Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  hintText: '+1',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Password Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Implement forgot password
                      },
                      child: const Text(
                        'FORGOT',
                        style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Login Button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context){
                 return TaskManagerHomepage();
               }));
              },
              icon: const Icon(Icons.login),
              label: const Text('Login',style:  TextStyle(color: Colors.black),),
            ),

            const SizedBox(height: 30),

            // Social Icons Row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(FontAwesomeIcons.apple, size: 24),
                SizedBox(width: 20),
                Icon(FontAwesomeIcons.facebookF, color: Colors.blue, size: 24),
                SizedBox(width: 20),
                Icon(FontAwesomeIcons.google, color: Colors.red, size: 24),
                SizedBox(width: 20),
                Icon(FontAwesomeIcons.twitter, color: Colors.blueAccent, size: 24),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
