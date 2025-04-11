import 'package:flutter/material.dart';

class EmailSection extends StatelessWidget {
  final String email;

  const EmailSection({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.07,
      height: size.height - 82,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RotatedBox(
            quarterTurns: 45,
            child: Text(
              email,
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 4.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              height: size.height * 0.25,
              width: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
