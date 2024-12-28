import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ku360/components/button.dart';
import 'package:ku360/utils/api_service.dart';
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
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isOtpSent = false;
  bool isOtpVerified = false;
  bool isLoading = false;

  // Email validation
  String? validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    RegExp regExp = RegExp(pattern);
    if (email.isEmpty) {
      return 'Please enter an email';
    } else if (!regExp.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Confirm Password validation
  String? validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> sendOtp() async {
    String email = emailController.text.trim();
    String? emailError = validateEmail(email);

    if (emailError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(emailError)));
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await ApiService.sendOtp(email); // Assume this API call sends the OTP
      setState(() {
        isOtpSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent to your email.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending OTP: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> verifyOtp() async {
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the OTP.')));
      return;
    }

    try {
      bool isVerified = await ApiService.verifyOtp(emailController.text, otp);
      if (isVerified) {
        setState(() {
          isOtpVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP verified. Proceed to register.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid OTP.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying OTP: $e')));
    }
  }

  Future<void> registerUser() async {
    if (!isOtpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify OTP first.')));
      return;
    }

    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();
    String? passwordError = validatePassword(password);
    String? confirmPasswordError =
    validateConfirmPassword(password, confirmPassword);

    if (passwordError != null || confirmPasswordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(passwordError ?? confirmPasswordError!)));
      return;
    }

    // Call API to register
    // Implement registration logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                prefixIcon: const Icon(Iconsax.sms),
              ),
              const SizedBox(height: 12),
              if (isOtpSent && !isOtpVerified)
                Column(
                  children: [
                    MyTextField(
                      controller: otpController,
                      hintText: "Enter OTP",
                      obscureText: false,
                      prefixIcon: const Icon(Iconsax.key),
                    ),
                    const SizedBox(height: 12),
                    MyButton(onTap: verifyOtp, text: "Verify OTP"),
                  ],
                ),
              if (isOtpVerified)
                Column(
                  children: [
                    MyTextField(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                      prefixIcon: const Icon(Iconsax.lock),
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: "Confirm Password",
                      obscureText: true,
                      prefixIcon: const Icon(Iconsax.lock),
                    ),
                    const SizedBox(height: 20),
                    MyButton(onTap: registerUser, text: "Register"),
                  ],
                ),
              if (!isOtpSent && !isLoading)
                MyButton(onTap: sendOtp, text: "Send OTP"),
              if (isLoading)
                const CircularProgressIndicator(),
              const SizedBox(height: 25),
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
            ],
          ),
        ),
      ),
    );
  }
}
