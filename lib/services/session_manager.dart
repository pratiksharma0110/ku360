import 'package:flutter/material.dart';
import 'package:ku360/services/login_or_register.dart';
import 'package:ku360/services/on_boarding_or_home.dart';
import 'package:ku360/services/user_service.dart';

class SessionHandlerPage extends StatefulWidget {
  const SessionHandlerPage({super.key});

  @override
  State<SessionHandlerPage> createState() => _SessionHandlerPageState();
}

class _SessionHandlerPageState extends State<SessionHandlerPage> {
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: userService.verifyToken(),
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
              MaterialPageRoute(builder: (context) => const OnboardingOrHomePage()),
            );
          });
          return const SizedBox(); 
        } else {
        
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginOrRegister()),
            );
          });
          return const SizedBox(); 
        }
      },
    );
  }
}
