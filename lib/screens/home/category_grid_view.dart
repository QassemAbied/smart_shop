import 'package:flutter/material.dart';
import 'package:new_store_app/widget/text_widget.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';

class CategoryGridView extends StatelessWidget {
  const CategoryGridView({super.key, required this.image, required this.title});
  final String image;
  final String title;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        children: [
          Image(
            image: AssetImage(
              image,
            ),
            fit: BoxFit.cover,
          ),
          const SizedBox(
            height: 5,
          ),
          FittedBox(
            child: TextWidget(
              text: title,
              maxLines: 1,
              color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
