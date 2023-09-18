import 'package:flutter/material.dart';
import '../text_widget.dart';

class GoogleBottom extends StatelessWidget {
  const GoogleBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          // googleSignIn();
        },
        child: Container(
          width: 150,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.teal.shade800,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image(
                image: AssetImage('assets/images/55.png'),
                width: 40.0,
                fit: BoxFit.fill,
              ),
              TextWidget(
                  text: ' Google',
                  sizeText: 23,
                  maxLines: 1,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
