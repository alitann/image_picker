import 'package:image_picker/image_picker.dart';

class CreateCollageViewModel {
  Future pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
    } catch (e) {}
  }
}
