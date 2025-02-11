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
  String businessType = 'businessType';
  String industry = 'industry';
  String businessLogo = '';
  String fullName = 'fullName';
  String role = 'role';
  String phone = 'phone';
  String employeeCount = '';
  String revenue = 'N/A';
  String gstin = 'N/A';
  String registrationNumber = 'N/A';

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

    final String? businessDataString = prefs.getString('businessData');
    if (businessDataString != null) {
      final Map<String, dynamic> businessData = jsonDecode(businessDataString);
      setState(() {
        businessName = businessData['businessName'] ?? 'Business Name';
        businessType = businessData['businessType'] ?? 'Business Type';
        industry = businessData['industry'] ?? 'Industry';
        businessLogo = businessData['businessLogo'] ?? '';
        employeeCount = businessData['employeeCount'] ?? '';
        revenue = businessData['revenue'] ?? 'N/A';
        gstin = businessData['gstin'] ?? 'N/A';
        registrationNumber = businessData['registrationNumber'] ?? 'N/A';
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    final String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final Map<String, dynamic> userData = jsonDecode(userDataString);
      setState(() {
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
                  _buildBusinessHeader(),
                  const SizedBox(height: 20),
                  _quickActionButton(Icons.edit, "Edit Profile", () {}),
                  const SizedBox(height: 20),
                  _buildBusinessDetailsCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildBusinessHeader() {
    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) return "Good Morning";
      if (hour < 17) return "Good Afternoon";
      return "Good Evening";
    }

    final greeting =
        "${getGreeting()}, ${fullName.isNotEmpty ? fullName.split(' ')[0] : email.split('@')[0].toUpperCase()}!";

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
        ],
      ),
      child: Row(
        children: [
          // userLogo.isNotEmpty
          //     ? ClipRRect(
          //   borderRadius: BorderRadius.circular(50),
          //   child: Image.file(
          //     File(businessLogo),
          //     height: 70,
          //     width: 70,
          //     fit: BoxFit.cover,
          //   ),
          // )
          //     :
          const Icon(Icons.person, size: 70, color: Colors.grey),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                businessName,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessDetailsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Business Name", businessName),
            _buildInfoRow("Email", email),
            _buildInfoRow("Business Type", businessType),
            _buildInfoRow("Industry", industry),
            _buildInfoRow("Role", role),
            _buildInfoRow("Phone", phone),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    if (value.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: $value", style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _quickActionButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onPressed,
    );
  }
}
