import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingController extends GetxController {
  var currentStep = 0.obs;
  var businessName = ''.obs;
  var contactEmail = ''.obs;
  var businessLogo = ''.obs;

  void nextStep() => currentStep.value++;

  void previousStep() => currentStep.value--;

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('businessName', businessName.value);
    await prefs.setString('contactEmail', contactEmail.value);
    await prefs.setString('businessLogo', businessLogo.value);
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      businessLogo.value = pickedFile.path;
    }
  }
}
