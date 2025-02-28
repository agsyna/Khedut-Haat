import 'package:image_picker/image_picker.dart';
import 'package:krish_biz/utils/common_utils.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if(file!=null) {
    return await file.readAsBytes();
  }

  print("NO IMAGE SELECTED");
  CUtils.toastMessage("No Image Selected");
}