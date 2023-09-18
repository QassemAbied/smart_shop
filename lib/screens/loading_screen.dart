import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme_provider.dart';

class LoadingManagerScreen extends StatelessWidget {
  const LoadingManagerScreen(
      {super.key, required this.isLoading, required this.child});
  final bool isLoading;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Container(
            color: themeProvider.getDarkTheme
                ? Colors.white.withOpacity(0.7)
                : Colors.black.withOpacity(0.7),
          ),
          Center(
              child: CircularProgressIndicator(
            color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
          )),
        ],
      ],
    );
  }
}
