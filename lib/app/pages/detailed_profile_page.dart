import 'package:flutter/material.dart';
import 'package:onespace/app/services/auth_service.dart'; // Import authService

class DetailedProfilePage extends StatelessWidget {
  const DetailedProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authService.value.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://www.example.com/your-profile-image.jpg',
              ),
            ),
          ),
          // Profile options list
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.white),
            title: Text(
              'Favorites',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {

              Navigator.pushNamed(context, '/favorites');
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.white),
            title: Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {

              Navigator.pushNamed(context, '/privacy-policy');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.white),
            title: Text(
              'Help',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/help');
            },
          ),
          Divider(),
          // Logout button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              await authService.value.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
