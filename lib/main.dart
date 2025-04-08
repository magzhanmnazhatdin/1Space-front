import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/pages/home_page.dart';
import 'app/pages/login_page.dart';
import 'app/services/auth_service.dart';
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
            textTheme: TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
            ),
            scaffoldBackgroundColor: Color(0xFF141414),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF141414),
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Color(0xFFE2F163),
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Color(0xFFE2F163)),
            )
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