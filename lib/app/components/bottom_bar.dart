import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../pages/state_page.dart';
import '../pages/search_page.dart';
import '../pages/home_page.dart';
import '../pages/shopping_cart_page.dart';
import '../pages/profile_page.dart';


class CustomGNavBar extends StatefulWidget {
  @override
  _CustomGNavBarState createState() => _CustomGNavBarState();
}

class _CustomGNavBarState extends State<CustomGNavBar> {
  int _selectedIndex = 2;  // Default to Home page

  // List of pages corresponding to each tab
  final List<Widget> _pages = [
    StatePage(),     // State
    SearchPage(),    // Placeholder for Search Page
    HomePage(),      // Home page itself
    CartPage(),      // Cart Page
    ProfilePage(),   // Profile page
  ];

  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;  // Update the selected tab index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  // Display the page based on selected tab
      bottomNavigationBar: GNav(
        color: Colors.white,
        activeColor: Color(0xFFE2F163),
        tabBackgroundColor: Colors.grey.shade800,
        gap: 8,
        onTabChange: _onTabChange,  // Call the method to change tab
        selectedIndex: _selectedIndex,  // Highlight the selected tab
        padding: EdgeInsets.all(16),
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
