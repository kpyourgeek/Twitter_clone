import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_iconic/constants/appwrite/appwrite_constants.dart';
import 'package:the_iconic/constants/appwrite/appwrite_providers.dart';

final storageApiProvider = Provider(
  (ref) {
    final storage = ref.watch(appwriteStorageProvider);
    return StorageApi(storage: storage);
  },
);

@immutable
class StorageApi {
  final Storage _storage;
  const StorageApi({required Storage storage}) : _storage = storage;

  Future<List<String>> uploadImages(List<File> files) async {
    final List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imageBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );

      imageLinks.add(AppwriteConstants.imageUrl(uploadedImage.$id));
    }
    return imageLinks;
  }
}
