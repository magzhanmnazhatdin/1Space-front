import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'my_bookings_page.dart';
import '../components/my_button.dart';
import 'detailed_profile_page.dart';
import 'club_manage_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void myBookingsPageOpen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyBookingsPage()),
    );
  }

  void manageClubsPageOpen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ClubManagePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isAdmin = authService.isAdmin;
    final isManager = authService.isManager;
    final showRank = !isAdmin && !isManager;
    final canManage = isAdmin || isManager;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ... баннер и Week Stats ...

          const SizedBox(height: 16),
          if (showRank) ...[
            // ... блок ранга ...
            const SizedBox(height: 20),
          ],

          // Details
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DetailedProfilePage()),
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

          const SizedBox(height: 20),

          // My Bookings
          MyButton(
            onTap: () => myBookingsPageOpen(context),
            text: 'My Bookings',
            icon: Icons.edit_calendar,
          ),

          const SizedBox(height: 20),

          // Manage Clubs — видим только для менеджеров и админов
          if (canManage)
            MyButton(
              onTap: () {
                // дополнительная защита
                if (!authService.isAdmin && !authService.isManager) return;
                manageClubsPageOpen(context);
              },
              text: 'Manage Clubs',
              icon: Icons.settings,
            ),
        ],
      ),
    );
  }
}
