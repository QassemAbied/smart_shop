import 'package:flutter/material.dart';
import '../text_widget.dart';

Future<void> showAlertDialogRegister({
  required BuildContext context,
  required String text,
  required String contentText,
}) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.error,
                color: Colors.red,
                size: 35,
              ),
              TextWidget(
                text: text,
                sizeText: 22,
                maxLines: 1,
                color: Colors.black,
              ),
            ],
          ),
          content: TextWidget(
            text: contentText,
            sizeText: 18,
            maxLines: 5,
            color: Colors.black,
          ),
          actions: const [
            TextWidget(
              text: 'Cancel',
              sizeText: 18,
              maxLines: 1,
              color: Colors.white,
            ),
          ],
        );
      });
}
