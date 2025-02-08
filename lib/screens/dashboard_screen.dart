import 'package:b2b_multistep_onboarding/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String businessName = '';
  String contactEmail = '';
  String businessLogo = '';

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      businessName = prefs.getString('businessName') ?? 'Not Set';
      contactEmail = prefs.getString('contactEmail') ?? 'Not Set';
      businessLogo = prefs.getString('businessLogo') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stored Data:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Business Name: $businessName'),
            Text('Contact Email: $contactEmail'),
            const SizedBox(height: 10),
            businessLogo.isNotEmpty
                ? Image.asset(
                    businessLogo,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : const Text('No Business Logo Selected'),
          ],
        ),
      ),
    );
  }
}
