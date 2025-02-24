import 'package:flutter/material.dart';

class HomeSectionTitle extends StatelessWidget {
  final String text;

  const HomeSectionTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .sizeOf(context)
        .width;
    double textFactor = width / 415;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: width * 0.05),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textFactor * 21,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
