import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ku360/components/button.dart';
import 'package:ku360/pages/authPages/login.dart';
import 'package:ku360/services/auth_service.dart';
import 'package:ku360/services/api_service.dart';   
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
  // Text controllers
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final otpController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isOtpSent = false;
  bool isOtpVerified = false;

  final authService = AuthService();  // Initialize AuthService

  Future<void> sendOtp() async {
    String email = emailController.text.trim();
    String? emailError = validateEmail(email);

    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(emailError)),
      );
      return;
    }

    try {
      await ApiService.sendOtp(email);  // Call ApiService to send OTP
      setState(() {
        isOtpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP sent to your email.")),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  Future<void> verifyOtp() async {
    String otp = otpController.text.trim();
    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the OTP")),
      );
      return;
    }

    try {
      final result = await ApiService.verifyOtp(
        emailController.text.trim(), otp,
      );  // Call ApiService to verify OTP
      if (result) {
        setState(() {
          isOtpVerified = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP verified successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid OTP")),
        );
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(err.toString())),
      );
    }
  }

  Future<void> registerUser() async {
    if (!isOtpVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please verify OTP before proceeding")),
      );
      return;
    }

    String firstname = firstnameController.text.trim();
    String lastname = lastnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Input validation
    String? firstnameError = validateRequiredField(firstname, 'First Name');
    String? lastnameError = validateRequiredField(lastname, 'Last Name');
    String? passwordError = validatePassword(password);
    String? confirmPasswordError =
        validateConfirmPassword(password, confirmPassword);

    List<String?> errors = [
      firstnameError,
      lastnameError,
      passwordError,
      confirmPasswordError,
    ];

    // Find first error
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
        password: password,
      );

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 36.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'REGISTER NOW',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 25),

              // First Name
              MyTextField(
                controller: firstnameController,
                hintText: "First Name",
                obscureText: false,
                prefixIcon: const Icon(Iconsax.user),
              ),
              const SizedBox(height: 12),

              // Last Name
              MyTextField(
                controller: lastnameController,
                hintText: "Last Name",
                obscureText: false,
                prefixIcon: const Icon(Iconsax.user_edit),
              ),
              const SizedBox(height: 12),

              // Email
              MyTextField(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
                prefixIcon: const Icon(Iconsax.sms),
              ),
              const SizedBox(height: 12),

              if (!isOtpVerified)
                Column(
                  children: [
                    // OTP
                    if (isOtpSent)
                      MyTextField(
                        controller: otpController,
                        hintText: "Enter OTP",
                        obscureText: false,
                        prefixIcon: const Icon(Iconsax.key),
                      ),
                    const SizedBox(height: 12),

                    // Send OTP or Verify OTP Button
                    MyButton(
                      onTap: isOtpSent ? verifyOtp : sendOtp,
                      text: isOtpSent ? "Verify OTP" : "Send OTP",
                    ),
                  ],
                ),
              if (isOtpVerified) ...[
                // Password
                const SizedBox(height: 12),
                MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                  prefixIcon: const Icon(Iconsax.lock),
                ),
                const SizedBox(height: 12),

                // Confirm Password
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true,
                  prefixIcon: const Icon(Iconsax.lock),
                ),
                const SizedBox(height: 20),

                MyButton(onTap: registerUser, text: "Register"),
              ],

              // Login Instead
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
