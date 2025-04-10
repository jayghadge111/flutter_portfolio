import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double textsize;
  final Color color;
  final double? letterSpacing;
  final FontWeight? fontWeight;

  const CustomText({
    super.key,
    required this.text,
    required this.textsize,
    required this.color,
    this.letterSpacing,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: textsize,
        letterSpacing: letterSpacing ?? 0.10,
        fontWeight: fontWeight ?? FontWeight.w400,
      ),
    );
  }
}
