import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'clubs_page.dart';
import 'login_page.dart';
import 'my_bookings_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = authService.value.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Главная'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.value.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Добро пожаловать!'),
            if (user?.email != null) Text('Email: ${user!.email}'),
            if (user?.displayName != null) Text('Имя: ${user!.displayName}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClubsPage()),
              ),
              child: Text('Просмотреть клубы'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyBookingsPage()),
              ),
              child: Text('Мои бронирования'),
            ),
          ],
        ),
      ),
    );
  }
}