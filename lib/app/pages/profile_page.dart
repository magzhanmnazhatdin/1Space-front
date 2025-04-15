import 'package:flutter/material.dart';
import 'package:onespace/app/components/my_button.dart';
import 'package:onespace/app/pages/detailed_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    void DetailedProfilePageOpen() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailedProfilePage()),
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
                image: AssetImage('lib/images/computer_aesthetic_banner.jpeg'), // replace with your actual image
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

          Row(
            children: const [
              Text('Played Time:', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(width: 8),
              Text('12h 34m', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: const [
              Text('Visits:', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(width: 8),
              Text('8', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: const [
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
            child: LinearProgressIndicator(
              value: 0.65,
              minHeight: 10,
              backgroundColor: Colors.grey.shade800,
              color: const Color(0xFFE2F163),
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

          // MyButton(
          //   onTap: DetailedProfilePageOpen,
          //   text: 'Details',
          //   icon: Icons.info
          // ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailedProfilePage()),
                );
              },
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
