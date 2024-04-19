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
}
