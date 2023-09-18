import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';

class PickImage extends StatelessWidget {
  const PickImage({
    super.key,
    this.imagePicked,
  });
  final XFile? imagePicked;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DottedBorder(
        color: themeProvider.getDarkTheme ? Colors.white : Colors.black,
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Container(
            height: 100,
            width: 100,
            color: Colors.teal,
            child: imagePicked == null
                ? const Image(
                    image: NetworkImage(
                        'https://images.assetsdelivery.com/compings_v2/4zevar/4zevar1604/4zevar160400009.jpg'))
                : Image.file(
                    File(imagePicked!.path),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      ),
    );
  }
}
