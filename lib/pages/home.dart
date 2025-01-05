import 'package:flutter/material.dart';
import 'package:ku360/services/login_or_register.dart';
import 'package:ku360/services/shared_pref.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SharedPrefHelper sharedPrefHelper = SharedPrefHelper();

  Future<void> logout() async {
    await sharedPrefHelper.removeValue("jwt_token");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginOrRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout, // Logout on press
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
