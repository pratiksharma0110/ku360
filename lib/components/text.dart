import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;

  const MyText({
    Key? key,
    required this.text,
    this.size = 16.0,
    this.weight = FontWeight.bold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
      ),
    );
  }
}
