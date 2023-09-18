import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import '../provider/theme_provider.dart';
import '../widget/text_widget.dart';

class MethodApp {
  static Future<void> showAlertDialog({
    context,
    required String contentText,
    required Function ftx,
    required String bottomText,
    bool? nextBottom,
  }) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          return AlertDialog(
            title: const Image(
              image: AssetImage('assets/images/warning.png'),
              width: 300,
              height: 100,
            ),
            content: TextWidget(
              text: contentText,
              sizeText: 20,
              maxLines: 2,
              color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
            ),
            actions: [
              nextBottom == true
                  ? ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const TextWidget(
                        text: 'Cancel',
                        sizeText: 18,
                        maxLines: 1,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () => ftx(),
                child: TextWidget(
                  text: bottomText,
                  sizeText: 18,
                  maxLines: 1,
                  color: Colors.red,
                ),
              )
            ],
          );
        });
  }

  static Future<void> ToastBar({
    required String text,
  }) {
    return Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey.shade300,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
