import 'package:flutter/material.dart';
import 'package:ku360/pages/on_boarding/on_boarding_page.dart';
import 'package:ku360/pages/screen.dart'; // Main screen page
import 'package:ku360/services/user_service.dart'; // Service for API calls

class OnboardingOrHomePage extends StatefulWidget {
  const OnboardingOrHomePage({super.key});

  @override
  State<OnboardingOrHomePage> createState() => _OnboardingOrHomePageState();
}

class _OnboardingOrHomePageState extends State<OnboardingOrHomePage> {
  final UserService userService = UserService();

  

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: userService.checkOnboardingStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('An error occurred: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Screen()),
            );
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OnBoardingPage()),
            );
          });
        }

        return const SizedBox();
      },
    );
  }
}
