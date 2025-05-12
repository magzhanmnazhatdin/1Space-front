import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            '''
We take your privacy seriously. This Privacy Policy explains how we collect, use, and protect your personal information.

1. Information Collection
• We collect your name, email address, and profile data when you register.

2. Usage of Information
• We use your data to authenticate you, process bookings, and send notifications.

3. Data Sharing
• We do not share your personal information with third parties except for payment processing.

4. Your Choices
• You can update or delete your profile at any time in the app settings.

5. Security
• We use industry-standard measures to protect your data.

If you have any questions, contact us at support@example.com.
''',
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
        ),
      ),
    );
  }
}
