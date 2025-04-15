// home_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'clubs_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ClubsPage()),
            ),
            child: const Text('View Clubs'),
          ),
        ],
      ),
    );
  }
}