import 'package:flutter/material.dart';

import 'custom_text.dart';

class MainTitle extends StatelessWidget {
  final String number;
  final String text;
  
  const MainTitle({
    super.key, 
    required this.number, 
    required this.text,
  });
  
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: number,
          textsize: 20.0,
          color: const Color(0xff61F9D5),
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(width: 12.0),
        CustomText(
          text: text,
          textsize: 26.0,
          color: const Color(0xffCCD6F6),
          fontWeight: FontWeight.w700,
        ),
        const SizedBox(width: 26.0),
        Container(
          width: MediaQuery.of(context).size.width / 4,
          height: 0.75,
          color: const Color(0xff303C55),
        ),
      ],
    );
  }
}