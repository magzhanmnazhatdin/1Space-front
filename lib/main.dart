import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onespace/app/components/bottom_bar.dart';
import 'app/pages/login_page.dart';
import 'app/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('ru', 'RU'), // Русский
            const Locale('en', 'US'), // Английский
          ],
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
          home: auth.currentUser != null ? CustomGNavBar() : LoginPage(),
          routes: {
            '/login': (context) => LoginPage(),
            '/home': (context) => CustomGNavBar(),
          },
        );
      },
    );
  }
}