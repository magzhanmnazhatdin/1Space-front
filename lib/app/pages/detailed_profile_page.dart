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
          style: TextStyle(color: Colors.white), // Set AppBar title text color to white
        ),
        backgroundColor: Colors.black, // Optional: Set AppBar background color
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white), // Set icon color to white
            onPressed: () async {
              // Accessing the signOut method using authService.value
              await authService.value.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Header section with user information (optional)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                'https://www.example.com/your-profile-image.jpg', // Replace with user profile image
              ),
            ),
          ),
          // Profile options list
          ListTile(
            leading: Icon(Icons.favorite, color: Colors.white), // Set icon color to white
            title: Text(
              'Favorites',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            onTap: () {
              // Handle navigation to favorites page
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          ListTile(
            leading: Icon(Icons.security, color: Colors.white), // Set icon color to white
            title: Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            onTap: () {
              // Handle navigation to privacy policy page
              Navigator.pushNamed(context, '/privacy-policy');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white), // Set icon color to white
            title: Text(
              'Settings',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            onTap: () {
              // Handle navigation to settings page
              Navigator.pushNamed(context, '/settings');
            },
          ),
          ListTile(
            leading: Icon(Icons.help, color: Colors.white), // Set icon color to white
            title: Text(
              'Help',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            onTap: () {
              // Handle navigation to help page
              Navigator.pushNamed(context, '/help');
            },
          ),
          Divider(),
          // Logout button
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white), // Set icon color to white
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            onTap: () async {
              // Sign out and navigate to login page
              await authService.value.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      backgroundColor: Colors.black, // Optional: Set background color of the page
    );
  }
}
