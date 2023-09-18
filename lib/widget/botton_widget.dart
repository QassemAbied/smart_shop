import 'package:flutter/material.dart';
import 'package:new_store_app/widget/title_text_widget.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class BottomWidget extends StatelessWidget {
  final Color color;
  final Function onPressed;
  final String text;
  final IconData icon;
  const BottomWidget(
      {super.key,
      required this.color,
      required this.onPressed,
      required this.text,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          )),
      onPressed: () => onPressed(),
      icon: Icon(icon),
      label: TitleTextWidget(
        text: text,
        fontSize: 23,
        color: color,
      ),
    );
  }
}
