import 'package:flutter/material.dart';
import 'package:ku360/pages/screen.dart';
import 'package:ku360/services/login_or_register.dart';

import '../services/shared_pref.dart';

class SessionHandlerPage extends StatefulWidget {
  const SessionHandlerPage({Key? key}) : super(key: key);

  @override
  State<SessionHandlerPage> createState() => _SessionHandlerPageState();
}

class _SessionHandlerPageState extends State<SessionHandlerPage> {
  final SharedPrefHelper sharedPrefHelper = SharedPrefHelper();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await sharedPrefHelper.getValue("jwt_token");

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Screen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginOrRegister()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
