import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double sizeText;
  final FontWeight fontWeight;
  final TextOverflow overflow;
  final int maxLines;
  final Color color;
  final FontStyle fontStyle;
  final TextDecoration decoration;
  const TextWidget(
      {super.key,
      required this.text,
      this.sizeText = 18,
      this.fontWeight = FontWeight.normal,
      this.overflow = TextOverflow.ellipsis,
      required this.maxLines,
      required this.color,
      this.fontStyle = FontStyle.normal,
      this.decoration = TextDecoration.none});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: sizeText,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        decoration: decoration,
      ),
    );
  }
}
