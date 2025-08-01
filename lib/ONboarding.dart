
import 'package:flutter/material.dart';
import 'package:page_flip/page_flip.dart';
import 'package:taskmanager/Signup.dart';

class OnboardingScreen1 extends StatelessWidget {
  final GlobalKey<PageFlipWidgetState> _flipKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageFlipWidget(
        key: _flipKey,
        backgroundColor: Colors.white,
        children: [
          buildPage(
            context,
            title: "Plan Your Day",
            description: "Easily create, edit and manage your daily tasks.",
            color: Colors.deepPurple[100]!,
            icon: Icons.calendar_today,
          ),
          buildPage(
            context,
            title: "Stay Focused",
            description: "Track your productivity and stay motivated.",
            color: Colors.teal[100]!,
            icon: Icons.track_changes,
          ),
          buildPage(
            context,
            title: "Achieve More",
            description: "Complete tasks on time and celebrate success.",
            color: Colors.orange[100]!,
            icon: Icons.emoji_events,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget buildPage(
      BuildContext context, {
        required String title,
        required String description,
        required Color color,
        required IconData icon,
        bool isLast = false,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 120,
              color: isDark ? Colors.white : Colors.deepPurple,
            ),
            const SizedBox(height: 30),
            Text(
              title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            if (isLast)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return SignupScreen(); // Or LoginScreen
                    }),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? Colors.white : Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    fontSize: 18,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
