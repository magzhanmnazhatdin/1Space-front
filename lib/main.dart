// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'app/components/bottom_bar.dart';
import 'app/models/booking_model.dart';
import 'app/pages/club_computers_page.dart';
import 'app/pages/faq_page.dart';
import 'app/pages/privacy_policy_page.dart';
import 'app/pages/login_page.dart';
import 'app/pages/detailed_profile_page.dart';
import 'app/pages/settings_page.dart';
import 'app/services/auth_service.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('ru_RU', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Инициализируем ключ
  Stripe.publishableKey = 'pk_test_51RMP6sQPF9VA2MpwMsgFmYamJQJTUaw8CXUAqJdkuDmDiHWoypviqmtiUsN0EySkx4LADoYqzewYWk72T3LMEE7y00Hhfnb6ac';
  // Если нужно, можно указать Apple Pay / Google Pay merchantId:
  // Stripe.merchantIdentifier = 'merchant.com.your.app';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ],
      child: const OneSpaceApp(),
    ),
  );
}

class OneSpaceApp extends StatelessWidget {
  const OneSpaceApp({super.key});

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
          title: 'OneSpace',
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
            // '/favorites': (context) => const FavoritesPage(),
            '/privacy-policy': (context) => const PrivacyPolicyPage(),
            '/settings': (context) => const SettingsPage(),
            '/faq': (context) => const FAQPage(),
            '/club-computers': (ctx){
              final args = ModalRoute.of(ctx)!.settings.arguments as ComputerClub;
              return ClubComputersPage(club: args);
            },
          },
        );
      },
    );
  }
}