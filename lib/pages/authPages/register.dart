import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ku360/components/button.dart';
import 'package:ku360/pages/authPages/login.dart';
import 'package:ku360/services/auth_service.dart';
import 'package:ku360/utils/user_functions.dart';

import '../../components/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({
    super.key,
    this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> registerUser() async {
    String firstname = firstnameController.text.trim();
    String lastname = lastnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Input validation
    String? firstnameError = validateRequiredField(firstname, 'First Name');
    String? lastnameError = validateRequiredField(lastname, 'Last Name');
    String? emailError = validateEmail(email);
    String? passwordError = validatePassword(password);
    String? confirmPasswordError =
        validateConfirmPassword(password, confirmPassword);

    List<String?> errors = [
      firstnameError,
      lastnameError,
      emailError,
      passwordError,
      confirmPasswordError,
    ];

    //find error:
    String? firstError =
        errors.firstWhere((err) => err != null, orElse: () => null);

    if (firstError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(firstError)));
      return;
    }
    try {
      final result = await authService.register(
          firstname: firstname,
          lastname: lastname,
          email: email,
          password: password);

      if (result['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(onTap: widget.onTap),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Registration failed')),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  @override
  void dispose() {
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60.0, left: 22),
                child: const Text(
                  'REGISTER NOW',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 36.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Name field
                      MyTextField(
                        controller: firstnameController,
                        hintText: "First Name",
                        obscureText: false,
                        prefixIcon: const Icon(Iconsax.user),
                      ),
                      const SizedBox(height: 12),

                      MyTextField(
                        controller: lastnameController,
                        hintText: "Last Name",
                        obscureText: false,
                        prefixIcon: const Icon(Iconsax.user_edit),
                      ),
                      const SizedBox(height: 12),

                      // Email field
                      MyTextField(
                        controller: emailController,
                        hintText: "Email",
                        obscureText: false,
                        prefixIcon: const Icon(Iconsax.sms),
                      ),
                      const SizedBox(height: 12),

                      // Password field
                      MyTextField(
                        controller: passwordController,
                        hintText: "Password",
                        obscureText: true,
                        prefixIcon: const Icon(Iconsax.lock),
                      ),
                      const SizedBox(height: 12),

                      // Confirm password field
                      MyTextField(
                        controller: confirmPasswordController,
                        hintText: "Confirm Password",
                        obscureText: true,
                        prefixIcon: const Icon(Iconsax.lock),
                      ),
                      const SizedBox(height: 20),

                      MyButton(onTap: registerUser, text: "Register "),
                      const SizedBox(height: 25),

                      // Not a member
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              "Login Instead",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
