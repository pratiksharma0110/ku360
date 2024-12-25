import 'package:flutter/material.dart';
import 'package:ku360/services/login_or_register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KU 360',
      home: LoginOrRegister(),
    );
  }
}

