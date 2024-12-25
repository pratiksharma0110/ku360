import "package:flutter/material.dart";

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool? obscureText;
  final Icon? prefixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          filled: true,
          prefixIcon: prefixIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 141, 138, 137),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
