import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survly/src/localization/localization_utils.dart';
import 'package:survly/src/service/permission_service.dart';

class PickerService {
  static Future<XFile?> takePhotoByCamera() async {
    if (await PermissionService.requestCameraPermission()) {
      return await ImagePicker().pickImage(source: ImageSource.camera);
    } else {
      Fluttertoast.showToast(msg: S.text.toastGrantCameraPermission);
      return null;
    }
  }

  static Future<XFile?> pickImageFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  static Future<DateTime?> pickDate(BuildContext context) async {
    final now = DateTime.now();
    return await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 65, 12, 31),
      lastDate: DateTime(now.year - 18, 12, 31),
      initialDatePickerMode: DatePickerMode.year,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );
  }
}
