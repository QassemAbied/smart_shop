import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNamedWidget extends StatelessWidget {
  const AppNamedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(seconds: 18),
      baseColor: Colors.red,
      highlightColor: Colors.yellow,
      child: const Text(
        'Shop Smart',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
