import 'package:flutter/material.dart';
import 'package:new_store_app/widget/text_widget.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextWidget(
            text: 'text',
            maxLines: 1,
            color: Colors.deepOrange,
            fontStyle: FontStyle.italic,
            sizeText: 29,
          ),
          SwitchListTile(
              value: themeProvider.getDarkTheme,
              title: const TextWidget(
                  text: 'Theme',
                  color: Colors.grey,
                  sizeText: 20,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1),
              onChanged: (value) {
                themeProvider.setDarkTheme(setDart: value);
              }),
        ],
      ),
    );
  }
}
