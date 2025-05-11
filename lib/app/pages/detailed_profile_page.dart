import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'settings_page.dart';

class DetailedProfilePage extends StatelessWidget {
  const DetailedProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final user = authService.currentUser;
    final isAdmin = authService.isAdmin;
    final isManager = authService.isManager;
    final showOrdinary = !isAdmin && !isManager;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (showOrdinary) ...[
            // Обёртка для круглой аватарки с контролем размера и fit
            Center(
              child: ClipOval(
                child: user?.photoURL != null
                    ? Image.network(
                  user!.photoURL!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  'https://www.example.com/default-profile-image.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],

          if (user?.displayName != null)
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white),
              title: Text(
                user!.displayName!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (user?.email != null)
            ListTile(
              leading: const Icon(Icons.email, color: Colors.white),
              title: Text(
                user!.email!,
                style: const TextStyle(color: Colors.white),
              ),
            ),

          const Divider(color: Colors.white30),

          if (showOrdinary)
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.white),
              title: const Text(
                'Favorites',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pushNamed(context, '/favorites'),
            ),

          ListTile(
            leading: const Icon(Icons.security, color: Colors.white),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pushNamed(context, '/privacy-policy'),
          ),

          // Settings — visible only for ordinary users
          if (showOrdinary)
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),

          ListTile(
            leading: const Icon(Icons.help, color: Colors.white),
            title: const Text(
              'Help',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pushNamed(context, '/help'),
          ),

          const Divider(color: Colors.white30),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              await authService.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Favorites Page')),
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Privacy Policy Page')),
    );
  }
}

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: Text('Settings Page')),
//     );
//   }
// }

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Help Page')),
    );
  }
}