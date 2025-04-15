// profile_page.dart

import 'package:flutter/material.dart';
import '../components/my_button.dart';
import 'detailed_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    void detailedProfilePageOpen() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetailedProfilePage()),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image: AssetImage('../images/computer_aesthetic_banner.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Week Stats',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Text('Played Time:', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(width: 8),
              Text('12h 34m', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Text('Visits:', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(width: 8),
              Text('8', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Text('Misses:', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(width: 8),
              Text('2', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Rank',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.65,
              minHeight: 10,
              backgroundColor: Colors.grey,
              color: Color(0xFFE2F163),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Level 3 - 65%',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: detailedProfilePageOpen,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE2F163),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}