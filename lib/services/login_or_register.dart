import 'package:flutter/widgets.dart';
import 'package:ku360/pages/authPages/login.dart';
import 'package:ku360/pages/authPages/register.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initally show login page to user:
  bool showLogin = true;

  void togglePages() {
    if (mounted) {
      setState(() {
        showLogin = !showLogin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return showLogin
        ? LoginPage(onTap: togglePages)
        : RegisterPage(onTap: togglePages);
  }
}
