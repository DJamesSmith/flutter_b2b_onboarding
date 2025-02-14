import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:b2b_multistep_onboarding/config/app_color.dart';
import 'package:b2b_multistep_onboarding/model/business_model.dart';
import 'package:b2b_multistep_onboarding/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class OnboardingController extends GetxController {
  var currentStep = 0.obs;

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController employeeCountController = TextEditingController();
  final TextEditingController revenueController = TextEditingController();
  final TextEditingController gstinController = TextEditingController();
  final TextEditingController registrationNumberController =
      TextEditingController();
  final TextEditingController panController = TextEditingController();

  var otpControllers = List.generate(4, (index) => TextEditingController()).obs;
  var otpFocusNodes = List.generate(4, (index) => FocusNode()).obs;

  var pan = ''.obs;
  var isPanValid = true.obs;
  var isLoading = false.obs;

  var remainingTime = 60.obs;
  Timer? _verificationCodeTimer;

  var isEmailVerified = false.obs;
  var generatedVerificationCode = ''.obs;
  var enteredVerificationCode = ''.obs;
  var isVerifyingEmail = false.obs;

  var isPhoneVerified = false.obs;
  var generatedPhoneOTP = ''.obs;
  var enteredPhoneOTP = ''.obs;
  var isVerifyingPhone = false.obs;

  var businessName = ''.obs;
  var businessType = ''.obs;
  var industry = ''.obs;
  var businessLogo = ''.obs;

  var businessTypes =
      ['Retail', 'Manufacturing', 'IT Services', 'Finance', 'Healthcare'].obs;
  var industries =
      ['E-commerce', 'Automobile', 'Education', 'Real Estate', 'Logistics'].obs;

  var selectedBusinessType = ''.obs;
  var selectedIndustry = ''.obs;

  var userImg = ''.obs;
  var fullName = ''.obs;
  var role = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;

  var employeeCount = ''.obs;
  var revenue = ''.obs;

  var gstin = ''.obs;
  var registrationNumber = ''.obs;

  var isBusinessNameValid = true.obs;
  var isBusinessTypeValid = true.obs;
  var isIndustryValid = true.obs;
  var isEmailValid = true.obs;
  var isPhoneValid = true.obs;

  void validateFields() {
    if (currentStep.value == 0) {
      isBusinessNameValid.value = businessName.value.isNotEmpty;
      isBusinessTypeValid.value = selectedBusinessType.value.isNotEmpty;
      isIndustryValid.value = selectedIndustry.value.isNotEmpty;
    } else if (currentStep.value == 1) {
      isPanValid.value = pan.value.isNotEmpty;
    } else if (currentStep.value == 2) {
      isEmailValid.value = isValidEmail(email.value);
      isPhoneValid.value = isValidPhone(phone.value);
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    );
    return emailRegex.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    final phoneRegex =
        RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$');
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    return phoneRegex.hasMatch(phone) && digitsOnly.length == 10;
  }

  bool canProceedToNextStep() {
    validateFields();

    if (currentStep.value == 0) {
      return isBusinessNameValid.value &&
          isBusinessTypeValid.value &&
          isIndustryValid.value;
    } else if (currentStep.value == 1) {
      return isPanValid.value;
    } else if (currentStep.value == 2) {
      return isEmailValid.value && isPhoneValid.value && isPhoneVerified.value;
    }

    return true;
  }

  void nextStep() {
    if (currentStep.value == 0 || currentStep.value == 2) {
      if (!canProceedToNextStep()) {
        Get.snackbar(
          "Error",
          "Please fill all required fields",
          backgroundColor: ColorFile.red,
          colorText: ColorFile.white,
        );
        return;
      }
    }
    currentStep.value++;
  }

  void previousStep() => currentStep.value--;

  void updateBusinessType(String value) => selectedBusinessType.value = value;

  void updateIndustry(String value) => selectedIndustry.value = value;

  Future<void> saveData() async {
    if (!canProceedToNextStep()) {
      Get.snackbar("Error", "Please complete the required fields",
          backgroundColor: ColorFile.red, colorText: ColorFile.white);
      return;
    }

    final business = Business(
      businessName: businessName.value,
      businessType: selectedBusinessType.value,
      industry: selectedIndustry.value,
      businessLogo: businessLogo.value,
      employeeCount: employeeCount.value,
      revenue: revenue.value,
      gstin: gstin.value,
      registrationNumber: registrationNumber.value,
    );

    final user = User(
      fullName: fullName.value,
      role: role.value,
      email: email.value,
      phone: phone.value,
      userImg: userImg.value,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('businessData', jsonEncode(business.toJson()));
    await prefs.setString('userData', jsonEncode(user.toJson()));
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) businessLogo.value = pickedFile.path;
  }

  Future<void> pickUserImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) userImg.value = pickedFile.path;
  }

  Future<void> verifyPan() async {
    isLoading.value = true;

    final url = Uri.parse('https://dg-sandbox.setu.co/api/verify/pan');
    final headers = {
      'content-type': 'application/json',
      'x-client-id': '292c6e76-dabf-49c4-8e48-90fba2916673',
      'x-client-secret': '7IZMe9zvoBBuBukLiCP7n4KLwSOy11oP',
      'x-product-instance-id': '439244ff-114e-41a8-ae74-a783f160622d',
    };

    final body = jsonEncode({
      'pan': pan.value,
      'consent': 'Y',
      'reason': 'Reason for verifying PAN set by the developer',
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final responseBody = jsonDecode(response.body);
      final verificationStatus = responseBody['verification'];
      final message = responseBody['message'];

      if (response.statusCode == 200) {
        Get.snackbar(
          responseBody['verification'],
          message,
          backgroundColor:
              verificationStatus == 'SUCCESS' ? ColorFile.green : ColorFile.red,
          colorText: ColorFile.white,
        );
        if (verificationStatus == 'SUCCESS') {
          final fullName = responseBody['data']['full_name'];
          fullNameController.text = fullName;
          nextStep();
        }
      } else {
        Get.snackbar(
          'Error',
          message,
          backgroundColor: ColorFile.red,
          colorText: ColorFile.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: ColorFile.red,
        colorText: ColorFile.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void sendEmailVerification() async {
    isVerifyingEmail.value = true;
    await Future.delayed(Duration(seconds: 2));

    final random = Random();
    generatedVerificationCode.value =
        (100000 + random.nextInt(899999)).toString();

    Get.snackbar(
      "Verification Code Sent",
      "Enter the Verification Code sent to ${emailController.text}",
      backgroundColor: ColorFile.blue,
      colorText: ColorFile.white,
    );

    debugPrint('Email Verify Code: ${generatedVerificationCode.value}');
    isVerifyingEmail.value = false;
  }

  void verifyVerificationCode(String verificationCode) {
    if (verificationCode == generatedVerificationCode.value) {
      isEmailVerified.value = true;
      Get.back();
      Get.snackbar(
        "Email Verified",
        "Your email has been successfully verified!",
        backgroundColor: ColorFile.green,
        colorText: ColorFile.white,
      );
    } else {
      Get.snackbar(
        "Invalid VerificationCode",
        "The VerificationCode you entered is incorrect. Please try again.",
        backgroundColor: ColorFile.red,
        colorText: ColorFile.white,
      );
    }
  }

  void startVerificationCodeTimer() {
    remainingTime.value = 15;
    _verificationCodeTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        _verificationCodeTimer?.cancel();
      }
    });
  }

  void resetVerificationCodeTimer() {
    _verificationCodeTimer?.cancel();
    startVerificationCodeTimer();
  }

  @override
  void onClose() {
    _verificationCodeTimer?.cancel();
    super.onClose();
  }

  void sendPhoneVerification() async {
    isVerifyingPhone.value = true;
    await Future.delayed(Duration(seconds: 2));

    for (var controller in otpControllers) {
      controller.clear();
    }

    final random = Random();
    generatedPhoneOTP.value = (1000 + random.nextInt(8999)).toString();

    Get.snackbar(
      "OTP Sent",
      "Enter the OTP sent to ${phoneController.text}",
      backgroundColor: ColorFile.blue,
      colorText: ColorFile.white,
    );

    debugPrint('Phone OTP: ${generatedPhoneOTP.value}');
    isVerifyingPhone.value = false;
  }

  void verifyPhoneOTP(String enteredOTP) {
    if (enteredOTP == generatedPhoneOTP.value) {
      isPhoneVerified.value = true;
      Get.back();
      Get.snackbar(
        "Phone Verified",
        "Your phone number has successfully been verified!",
        backgroundColor: ColorFile.green,
        colorText: ColorFile.white,
      );
    } else {
      Get.snackbar(
        "Invalid OTP",
        "The OTP you entered is incorrect. Please try again.",
        backgroundColor: ColorFile.red,
        colorText: ColorFile.white,
      );
    }
  }
}
