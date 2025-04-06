import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/auth_service.dart';
import 'app/auth_service.dart';
import 'app/home_page.dart';
import 'app/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
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