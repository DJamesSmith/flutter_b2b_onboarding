import 'dart:io';

import 'package:b2b_multistep_onboarding/config/app_color.dart';
import 'package:b2b_multistep_onboarding/widgets/show_animations.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:b2b_multistep_onboarding/widgets/app_components.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  bool isLoading = true;
  final AppComponents appComponents = AppComponents();

  String businessName = 'businessName';
  String email = 'dion@gmail.com';
  String userImg = '';
  String fullName = 'fullName';
  String role = 'role';
  String phone = 'phone';

  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _loadSavedData();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));

    final String? businessDataString = prefs.getString('businessData');
    if (businessDataString != null) {
      final Map<String, dynamic> businessData = jsonDecode(businessDataString);
      setState(
        () => businessName = businessData['businessName'] ?? 'Business Name',
      );
    }

    final String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
        userImg = userData['userImg'] ?? '';
        fullName = userData['fullName'] ?? '';
        role = userData['role'] ?? '';
        email = userData['email'] ?? 'Email';
        phone = userData['phone'] ?? '';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: isLoading
          ? _buildShimmerLoader()
          : FadeTransition(
              opacity: _fadeController,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 50),
                  _quickActionButton(Icons.edit, "Edit Profile", () {}),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    final userName = email.split('@')[0].toUpperCase();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              child: ShowAnimations().profileImgBG3(context),
            ),
            Positioned(
              child: ShowAnimations().profileImgBG4(context),
            ),
            userImg.isNotEmpty
                ? Container(
                    height: 170,
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(85),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(75),
                        child: Image.file(
                          File(userImg),
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Icon(Icons.person, size: 70, color: ColorFile.grey),
          ],
        ),
        SizedBox(height: 20),
        Text(
          fullName.isNotEmpty ? fullName : userName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        role.isNotEmpty
            ? Text(
                role,
                style: TextStyle(
                    fontWeight: FontWeight.w400, color: ColorFile.grey500),
              )
            : SizedBox(),
        Text(
          businessName,
          style:  TextStyle(fontSize: 16, color: ColorFile.grey),
        ),
      ],
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          ShowAnimations().profileImgBG2(context),
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 16,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: ColorFile.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 16,
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: ColorFile.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 50),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 50,
            decoration: BoxDecoration(
              color: ColorFile.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: Icon(icon, size: 18),
        label: Text(label, style: const TextStyle(fontSize: 13)),
        onPressed: onPressed,
      ),
    );
  }
}
