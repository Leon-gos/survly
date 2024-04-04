import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:survly/src/utils/file_helper.dart';

class FileData {
  static FileData? _instance;
  final storageRef = FirebaseStorage.instance.ref();

  factory FileData.instance() {
    _instance ??= FileData._();
    return _instance!;
  }

  FileData._();

  Future<String?> uploadFile(
      {required String filePath, required String fileKey}) async {
    try {
      await storageRef.child(fileKey).putFile(
            File(filePath),
            SettableMetadata(
              contentType:
                  "image/${FileHelper.getFileType(filePath: filePath)}",
            ),
          );
      return storageRef.child(fileKey).getDownloadURL();
    } catch (e) {
      Logger().e(e);
    }
    return null;
  }

  Future<String> getImageUrl(String imageKey) async {
    return await storageRef.child(imageKey).getDownloadURL();
  }
}
