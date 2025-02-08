import 'dart:io';
import 'package:b2b_multistep_onboarding/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppComponents {
  final OnboardingController controller = Get.find();

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget stepOne(BuildContext context) {
    return _buildCard(
      title: "Enter Business Name",
      icon: Icons.business,
      child: TextField(
        decoration: _inputDecoration("Business Name"),
        onChanged: (value) => controller.businessName.value = value,
      ),
    );
  }

  Widget stepTwo(BuildContext context) {
    return _buildCard(
      title: "Enter Contact Email",
      icon: Icons.email,
      child: TextField(
        decoration: _inputDecoration("Contact Email"),
        onChanged: (value) => controller.contactEmail.value = value,
      ),
    );
  }

  Widget stepThree(BuildContext context) {
    return _buildCard(
      title: "Upload Business Logo",
      icon: Icons.image,
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => controller.pickImage(),
            icon: const Icon(Icons.upload),
            label: const Text("Select Image"),
          ),
          const SizedBox(height: 10),
          Obx(
            () => controller.businessLogo.value.isNotEmpty
                ? Image.file(File(controller.businessLogo.value), height: 100)
                : const Text(
                    'No Image Selected',
                    style: TextStyle(color: Colors.grey),
                  ),
          ),
        ],
      ),
    );
  }

  Widget stepFour(BuildContext context) {
    return _buildCard(
      title: "Additional Business Details",
      icon: Icons.info,
      child: Column(
        children: [
          const Text('Business details form goes here...'),
          Chip(
            label: Text('Hello'),
            onDeleted: () => print('Deleted'),
          )
        ],
      ),
    );
  }

  Widget stepFive(BuildContext context) {
    return _buildCard(
      title: "Review & Complete",
      icon: Icons.check_circle,
      child: const Text('Review all details before completing the onboarding.'),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 30, color: Colors.deepPurple),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}
