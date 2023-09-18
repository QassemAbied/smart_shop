import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../widget/text_widget.dart';
import '../widget/title_text_widget.dart';

class EmptyForScreen extends StatelessWidget {
  final String image;
  final String title;
  final String subTitle;
  final String lastTitle;
  final String bottomTitle;
  final String textAppBar;
  final Function onPressed;

  const EmptyForScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.lastTitle,
    required this.bottomTitle,
    required this.onPressed,
    required this.textAppBar,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: TitleTextWidget(
          text: textAppBar,
          color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
        ),
        leading: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child:
              Image(image: AssetImage('assets/images/bag/shopping_cart.png')),
        ),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
        child: Column(
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image(
                image: AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TitleTextWidget(
              text: title,
              color:
                  themeProvider.getDarkTheme ? Colors.red : Colors.tealAccent,
              fontSize: 35,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: subTitle,
              maxLines: 1,
              fontWeight: FontWeight.bold,
              //overflow: TextOverflow.ellipsis,
              sizeText: 25,
              fontStyle: FontStyle.italic,
              color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWidget(
              text: lastTitle,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              sizeText: 18,
              fontStyle: FontStyle.italic,
              color: themeProvider.getDarkTheme ? Colors.white38 : Colors.grey,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white54,
                  minimumSize: const Size(100, 50),
                ),
                onPressed: () => onPressed(),
                child: TitleTextWidget(
                  text: bottomTitle,
                  color: Colors.black,
                  fontSize: 25,
                ))
          ],
        ),
      ),
    );
  }
}
