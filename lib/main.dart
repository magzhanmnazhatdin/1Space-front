// main.dart

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/components/bottom_bar.dart';
import 'app/pages/home_page.dart';
import 'app/pages/login_page.dart';
import 'app/pages/detailed_profile_page.dart';
import 'app/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ru_RU', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ru', 'RU'),
            Locale('en', 'US'),
          ],
          title: 'Firebase Auth Demo',
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
            scaffoldBackgroundColor: const Color(0xFF141414),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF141414),
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Color(0xFFE2F163),
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Color(0xFFE2F163)),
            ),
          ),
          initialRoute: auth.currentUser != null ? '/home' : '/login',
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => const CustomGNavBar(),
            '/favorites': (context) => const FavoritesPage(),
            '/privacy-policy': (context) => const PrivacyPolicyPage(),
            '/settings': (context) => const SettingsPage(),
            '/help': (context) => const HelpPage(),
          },
        );
      },
    );
  }
}