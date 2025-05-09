import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../pages/state_page.dart';
import '../pages/search_page.dart';
import '../pages/home_page.dart';
import '../pages/cart_page.dart';
import '../pages/profile_page.dart';

class CustomGNavBar extends StatefulWidget {
  const CustomGNavBar({super.key});

  @override
  _CustomGNavBarState createState() => _CustomGNavBarState();
}

class _CustomGNavBarState extends State<CustomGNavBar> {
  int _selectedIndex = 2;

  final List<Widget> _pages = const [
    StatePage(),
    SearchPage(),
    HomePage(),
    CartPage(),
    ProfilePage(),
  ];

  void _onTabChange(int index) {
    final authService = context.read<AuthService>();
    if (!authService.isLoggedIn && index != 2) {
      Navigator.pushNamed(context, '/login');
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GNav(
        color: Colors.white,
        activeColor: const Color(0xFFE2F163),
        tabBackgroundColor: Colors.grey.shade800,
        gap: 8,
        onTabChange: _onTabChange,
        selectedIndex: _selectedIndex,
        padding: const EdgeInsets.all(16),
        tabs: const [
          GButton(
            icon: Icons.calendar_month,
            text: 'State',
          ),
          GButton(
            icon: Icons.search,
            text: 'Search',
          ),
          GButton(
            icon: Icons.home,
            text: 'Home',
          ),
          GButton(
            icon: Icons.shopping_cart,
            text: 'Cart',
          ),
          GButton(
            icon: Icons.person,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}