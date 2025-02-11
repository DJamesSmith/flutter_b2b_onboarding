import 'dart:io';
import 'package:b2b_multistep_onboarding/config/app_color.dart';
import 'package:b2b_multistep_onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppComponents {
  final OnboardingController controller = Get.find();

  InputDecoration _inputDecoration({
    String? title,
    Icon? prefixIcon,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: title,
      prefixIcon: prefixIcon,
      errorText: errorText,
    );
  }

  Widget stepOne(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageUploader(),
          SizedBox(height: 20),
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
        ),
        'onChanged': (value) {
          controller.email.value = value;
          controller.validateFields();
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
        ),
        'onChanged': (value) {
          controller.phone.value = value;
          controller.validateFields();
        },
        'maxLength': controller.isPhoneValid.value ? null : 10,
        'keyboardType': TextInputType.phone,
      },
    ];
  }

  Widget stepTwo(BuildContext context) {
    final arrProfileTxtFld = profileTxtFldHints();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: List.generate(arrProfileTxtFld.length, (index) {
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
              maxLength:
                  txtFld.containsKey('maxLength') ? txtFld['maxLength'] : null,
            ),
          );
        }),
      ),
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

  Widget stepThree(BuildContext context) {
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

  Widget stepFour(BuildContext context) {
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

  Widget stepFive(BuildContext context) {
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
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploader() {
    return GestureDetector(
      onTap: () => controller.pickImage(),
      child: Row(
        children: [
          Obx(
            () => controller.businessLogo.value.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.file(
                      File(controller.businessLogo.value),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.camera_alt),
                  ),
          ),
          SizedBox(width: 20),
          Text('Business Logo'),
        ],
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
          color: Colors.black87,
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
          Text(value, style: TextStyle(color: Colors.black54)),
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
              style: TextStyle(color: Colors.grey),
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
}
