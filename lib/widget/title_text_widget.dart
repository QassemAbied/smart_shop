import 'package:flutter/material.dart';

class TitleTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  const TitleTextWidget(
      {super.key, required this.text, required this.color, this.fontSize = 20});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontStyle: FontStyle.italic,
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis),
    );
  }
}
