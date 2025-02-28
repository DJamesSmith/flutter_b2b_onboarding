import 'dart:io';
import 'package:b2b_multistep_onboarding/config/app_color.dart';
import 'package:b2b_multistep_onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppComponents {
  final OnboardingController controller = Get.find();

  InputDecoration _inputDecoration({
    String? title,
    Icon? prefixIcon,
    String? errorText,
    suffixIcon,
  }) {
    return InputDecoration(
      labelText: title,
      prefixIcon: prefixIcon,
      errorText: errorText,
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildDropdown({
    String? title,
    List<String>? items,
    RxString? selectedValue,
    Function(String)? onChanged,
    String? myValueTypes,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        return DropdownButtonFormField<String>(
          decoration: _inputDecoration(
            title: title,
            prefixIcon: Icon(Icons.category),
            errorText: errorText,
          ),
          value: myValueTypes,
          items: items?.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              debugPrint('${title ?? ''}: ${newValue ?? ''}');
              onChanged!(newValue);
            }
            controller.validateFields();
          },
        );
      }),
    );
  }

  List<Map<String, dynamic>> profileTxtFldHints() {
    return [
      {
        'controllerName': controller.fullNameController,
        'inputDeco': _inputDecoration(
          title: "Full Name",
          prefixIcon: Icon(Icons.person),
        ),
        'onChanged': (value) => controller.fullName.value = value,
      },
      {
        'controllerName': controller.roleController,
        'inputDeco': _inputDecoration(
          title: "Role in Business",
          prefixIcon: Icon(Icons.work),
        ),
        'onChanged': (value) => controller.role.value = value,
      },
      {
        'controllerName': controller.emailController,
        'inputDeco': _inputDecoration(
          title: "Email",
          prefixIcon: Icon(Icons.email),
          errorText: controller.isEmailValid.value ? null : "Invalid Email",
          suffixIcon: Obx(
            () {
              bool isEmailValid =
                  controller.isValidEmail(controller.emailController.text);

              return controller.isEmailVerified.value
                  ? Icon(Icons.verified, color: ColorFile.green)
                  : TextButton(
                      onPressed:
                          (!isEmailValid || controller.isVerifyingEmail.value)
                              ? null
                              : () {
                                  controller.sendEmailVerification();
                                  showVerificationCodeDialog();
                                },
                      child: controller.isVerifyingEmail.value
                          ? Transform.scale(
                              scale: 0.5,
                              child: CircularProgressIndicator(),
                            )
                          : Text("Verify"),
                    );
            },
          ),
        ),
        'onChanged': (value) {
          controller.email.value = value;
          controller.isEmailValid.value = controller.isValidEmail(value);
          if (controller.isEmailVerified.value) {
            controller.isEmailVerified.value = false;
          }
        },
        'keyboardType': TextInputType.emailAddress,
      },
      {
        'controllerName': controller.phoneController,
        'inputDeco': _inputDecoration(
          title: "Phone",
          prefixIcon: Icon(Icons.phone),
          errorText:
              controller.isPhoneValid.value ? null : "Invalid phone number",
          suffixIcon: Obx(
            () {
              bool isPhoneValid =
                  controller.isValidPhone(controller.phoneController.text);

              return controller.isPhoneVerified.value
                  ? Icon(Icons.verified, color: ColorFile.green)
                  : TextButton(
                      onPressed:
                          (!isPhoneValid || controller.isVerifyingPhone.value)
                              ? null
                              : () {
                                  controller.sendPhoneVerification();
                                  showPhoneOTPDialog();
                                },
                      child: controller.isVerifyingPhone.value
                          ? Transform.scale(
                              scale: 0.5,
                              child: CircularProgressIndicator(),
                            )
                          : Text("Verify"),
                    );
            },
          ),
        ),
        'onChanged': (value) {
          controller.phone.value = value;
          controller.validateFields();
          if (controller.isPhoneVerified.value) {
            controller.isPhoneVerified.value = false;
          }
        },
        'maxLength': controller.isPhoneValid.value ? null : 10,
        'keyboardType': TextInputType.phone,
      },
    ];
  }

  void showPhoneOTPDialog() {
    controller.startVerificationCodeTimer();

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "Verification Code Modal",
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Obx(
          () => Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black26)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Enter 4-digit Verification Code",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 50,
                          child: TextField(
                            controller: controller.otpControllers[index],
                            focusNode: controller.otpFocusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(counterText: ""),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                if (index < 3) {
                                  FocusScope.of(context).requestFocus(
                                    controller.otpFocusNodes[index + 1],
                                  );
                                }
                              } else {
                                if (index > 0) {
                                  FocusScope.of(context).requestFocus(
                                    controller.otpFocusNodes[index - 1],
                                  );
                                }
                              }
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'[^0-9]')),
                              LengthLimitingTextInputFormatter(1),
                            ],
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 20),
                    if (controller.remainingTime.value > 0)
                      Text(
                        "Time remaining: ${controller.remainingTime.value} seconds",
                        style: TextStyle(color: Colors.grey),
                      ),
                    if (controller.remainingTime.value == 0)
                      TextButton(
                        onPressed: () {
                          controller.sendPhoneVerification();
                          controller.resetVerificationCodeTimer();
                        },
                        child: Text("Re-send code"),
                      ),
                    SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        final enteredOtp = controller.otpControllers
                            .map((controller) => controller.text)
                            .join();
                        controller.verifyPhoneOTP(enteredOtp);
                        Get.back();
                      },
                      child: Container(
                        height: 48,
                        width: 120,
                        decoration: BoxDecoration(
                          color: ColorFile.blueAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            "Verify",
                            style: TextStyle(color: ColorFile.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.0).animate(anim1),
            child: child,
          ),
        );
      },
    ).then((_) {
      for (var focusNode in controller.otpFocusNodes) {
        focusNode.unfocus();
      }
      for (var controller in controller.otpControllers) {
        controller.clear();
      }
    });
  }

  void showVerificationCodeDialog() {
    controller.startVerificationCodeTimer();

    showGeneralDialog(
      context: Get.context!,
      barrierDismissible: true,
      barrierLabel: "Verification Code Modal",
      transitionDuration: Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Obx(() => Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: Colors.black26)
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enter Verification Code",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        onChanged: (value) =>
                            controller.enteredVerificationCode.value = value,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "6-digit Verification Code",
                        ),
                      ),
                      SizedBox(height: 10),
                      if (controller.remainingTime.value > 0)
                        Text(
                          "Time remaining: ${controller.remainingTime.value} seconds",
                          style: TextStyle(color: Colors.grey),
                        ),
                      if (controller.remainingTime.value == 0)
                        TextButton(
                          onPressed: () {
                            controller.sendEmailVerification();
                            controller.resetVerificationCodeTimer();
                          },
                          child: Text("Re-send code"),
                        ),
                      SizedBox(height: 30),
                      GestureDetector(
                        onTap:
                            controller.enteredVerificationCode.value.isNotEmpty
                                ? () => controller.verifyVerificationCode(
                                    controller.enteredVerificationCode.value)
                                : null,
                        child: Container(
                          height: 48,
                          width: 120,
                          decoration: BoxDecoration(
                            color: ColorFile.blueAccent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              "Verify",
                              style: TextStyle(color: ColorFile.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.0).animate(anim1),
            child: child,
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> operationsTxtFldHints() {
    return [
      {
        'controllerName': controller.employeeCountController,
        'inputDeco': _inputDecoration(
          title: "Employee Count",
          prefixIcon: Icon(Icons.group),
        ),
        'onChanged': (value) => controller.employeeCount.value = value,
        'keyboardType': TextInputType.number,
      },
      {
        'controllerName': controller.revenueController,
        'inputDeco': _inputDecoration(
          title: "Revenue",
          prefixIcon: Icon(Icons.attach_money),
        ),
        'onChanged': (value) => controller.revenue.value = value,
        'keyboardType': TextInputType.number,
      },
    ];
  }

  List<Map<String, dynamic>> legalTxtFldHints() {
    return [
      {
        'controllerName': controller.gstinController,
        'inputDeco': _inputDecoration(
          title: "GSTIN/TIN",
          prefixIcon: Icon(Icons.receipt),
        ),
        'onChanged': (value) => controller.gstin.value = value,
      },
      {
        'controllerName': controller.registrationNumberController,
        'inputDeco': _inputDecoration(
          title: "Registration Number",
          prefixIcon: Icon(Icons.verified),
        ),
        'onChanged': (value) => controller.registrationNumber.value = value,
      },
    ];
  }

  Widget _buildImageUploader({
    String? title,
    required RxString imagePath,
    required VoidCallback onPickImage,
    bool isUser = false,
  }) {
    return GestureDetector(
      onTap: onPickImage,
      child: isUser
          ? Center(child: imagePickerWidget(imagePath, isUser))
          : Row(
              children: [
                imagePickerWidget(imagePath, isUser),
                SizedBox(width: 20),
                Text(title ?? ''),
              ],
            ),
    );
  }

  Widget imagePickerWidget(RxString imagePath, bool isUser) {
    return Obx(
      () => imagePath.value.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                File(imagePath.value),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: ColorFile.grey300,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                isUser ? Icons.person : Icons.camera_alt,
                size: isUser ? 60 : 40,
                color: ColorFile.grey700,
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ColorFile.black87,
        ),
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: ColorFile.black54)),
        ],
      ),
    );
  }

  Widget _buildReviewImage() {
    return Obx(
      () {
        if (controller.businessLogo.value.isNotEmpty) {
          return Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.file(
                File(controller.businessLogo.value),
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return Center(
            child: Text(
              "No logo uploaded",
              style: TextStyle(color: ColorFile.grey),
            ),
          );
        }
      },
    );
  }

  String formatNumber(String value) {
    int? num = int.tryParse(value);

    if (num == null) return value;

    if (num >= 10000000) {
      return '${(num / 10000000).toStringAsFixed(1)} Cr';
    } else if (num >= 100000) {
      return '${(num / 100000).toStringAsFixed(1)} L';
    } else if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)} K';
    } else {
      return num.toString();
    }
  }

  Widget quickActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Expanded(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: onPressed,
      ),
    );
  }

  Widget stepOne(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _buildImageUploader(
            title: 'Business Logo',
            imagePath: controller.businessLogo,
            onPickImage: () => controller.pickImage(),
          ),
          SizedBox(height: 50),
          TextField(
            controller: controller.businessNameController,
            decoration: InputDecoration(
              labelText: "Business Name",
              prefixIcon: Icon(Icons.business),
              errorText:
                  controller.isBusinessNameValid.value ? null : "Required",
            ),
            onChanged: (value) => controller.businessName.value = value,
          ),
          SizedBox(height: 8),
          _buildDropdown(
            title: "Business Type",
            items: controller.businessTypes,
            selectedValue: controller.selectedBusinessType,
            onChanged: controller.updateBusinessType,
            myValueTypes: controller.selectedBusinessType.value.isNotEmpty
                ? controller.selectedBusinessType.value
                : null,
            errorText: controller.isBusinessTypeValid.value ? null : "Required",
          ),
          SizedBox(height: 8),
          _buildDropdown(
            title: "Industry",
            items: controller.industries,
            selectedValue: controller.selectedIndustry,
            onChanged: controller.updateIndustry,
            myValueTypes: controller.selectedIndustry.value.isNotEmpty
                ? controller.selectedIndustry.value
                : null,
            errorText: controller.isIndustryValid.value ? null : "Required",
          ),
        ],
      ),
    );
  }

  Widget stepTwo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          TextField(
            controller: controller.panController,
            decoration: _inputDecoration(
              title: 'PAN Number',
              prefixIcon: Icon(Icons.credit_card),
              errorText: controller.isPanValid.value ? null : "Invalid PAN",
            ),
            onChanged: (value) {
              controller.pan.value = value;
              controller.validateFields();
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget stepThree(BuildContext context) {
    final arrProfileTxtFld = profileTxtFldHints();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: [
          _buildImageUploader(
            isUser: true,
            imagePath: controller.userImg,
            onPickImage: () => controller.pickUserImage(),
          ),
          SizedBox(height: 20),
          ...List.generate(arrProfileTxtFld.length, (index) {
            final txtFld = arrProfileTxtFld[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                controller: txtFld['controllerName'],
                decoration: txtFld['inputDeco'],
                onChanged: txtFld['onChanged'],
                keyboardType: txtFld.containsKey('keyboardType')
                    ? txtFld['keyboardType']
                    : TextInputType.text,
                maxLength: txtFld.containsKey('maxLength')
                    ? txtFld['maxLength']
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget stepFour(BuildContext context) {
    final arrOperationsTxtFld = operationsTxtFldHints();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: List.generate(arrOperationsTxtFld.length, (index) {
          final txtFld = arrOperationsTxtFld[index];
          return TextField(
            controller: txtFld['controllerName'],
            decoration: txtFld['inputDeco'],
            onChanged: txtFld['onChanged'],
            keyboardType: txtFld.containsKey('keyboardType')
                ? txtFld['keyboardType']
                : TextInputType.text,
          );
        }),
      ),
    );
  }

  Widget stepFive(BuildContext context) {
    final arrLegalTxtFld = legalTxtFldHints();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: List.generate(arrLegalTxtFld.length, (index) {
          final txtFld = arrLegalTxtFld[index];
          return TextField(
            controller: txtFld['controllerName'],
            decoration: txtFld['inputDeco'],
            onChanged: txtFld['onChanged'],
          );
        }),
      ),
    );
  }

  Widget stepSix(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Business Information"),
            _buildReviewItem("Business Name", controller.businessName.value),
            _buildReviewItem(
                "Business Type", controller.selectedBusinessType.value),
            _buildReviewItem("Industry", controller.selectedIndustry.value),
            const SizedBox(height: 20),
            _buildSectionTitle("Contact Details"),
            _buildReviewItem("Email", controller.email.value),
            const SizedBox(height: 20),
            _buildSectionTitle("Business Logo"),
            _buildReviewImage(),
            const SizedBox(height: 30),
            Center(
              child: Text(
                "Please review your details before proceeding.",
                style: TextStyle(
                  fontSize: 14,
                  color: ColorFile.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
