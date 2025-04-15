import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'clubs_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = authService.value.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          if (user?.email != null) Text('Email: ${user!.email}'),
          if (user?.displayName != null) Text('Name: ${user!.displayName}'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClubsPage()),
            ),
            child: Text('View Clubs'),
          ),
        ],
      ),
    );
  }
}