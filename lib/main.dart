import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'utils/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/admin_login_screen.dart';
import 'screens/admin_dashboard_screen.dart';

void main() {
  runApp(const CampusTerangaApp());
}

class CampusTerangaApp extends StatelessWidget {
  const CampusTerangaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Campus Teranga',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFFE1701A, {
            50: const Color(0xFFFDF4E6),
            100: const Color(0xFFF9E3C1),
            200: const Color(0xFFF2C97C),
            300: const Color(0xFFEBAF37),
            400: const Color(0xFFE68F28),
            500: const Color(0xFFE1701A),
            600: const Color(0xFFD15E17),
            700: const Color(0xFFB84A14),
            800: const Color(0xFF9F3611),
            900: const Color(0xFF7A220C),
          }),
          primaryColor: AppColors.orangeVif,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.orangeVif,
            brightness: Brightness.light,
            primary: AppColors.orangeVif,
            secondary: AppColors.bleuNuit,
            surface: AppColors.blanc,
            background: AppColors.greyLight,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.blanc,
            foregroundColor: AppColors.bleuNuit,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.bleuNuit,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orangeVif,
              foregroundColor: AppColors.blanc,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          cardTheme: CardTheme(
            color: AppColors.blanc,
            elevation: 2,
            shadowColor: AppColors.cardShadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/home': (context) => const HomeScreen(),
          '/admin-login': (context) => const AdminLoginScreen(),
          '/admin-dashboard': (context) => const AdminDashboardScreen(),
        },
      ),
    );
  }
}