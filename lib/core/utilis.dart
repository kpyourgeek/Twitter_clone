import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  const Duration(seconds: 5);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
      showCloseIcon: true,
    ),
  );
}

String getNameFromEmail(String email) {
  return (email.split('@')[0]);
}

Future<List<File>> pickImages() async {
  final List<File> images = [];
  final ImagePicker imagePicker = ImagePicker();
  final imageFiles = await imagePicker.pickMultiImage();
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(File(image.path));
    }
  }
  return images;
}
