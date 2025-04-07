import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/pages/home_page.dart';
import 'app/pages/login_page.dart';
import 'app/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthService>(
      valueListenable: authService,
      builder: (context, auth, _) {
        return MaterialApp(
          title: 'Firebase Auth Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.currentUser != null ? HomePage() : LoginPage(),
          routes: {
            '/login': (context) => LoginPage(),
            '/home': (context) => HomePage(),
          },
        );
      },
    );
  }
}