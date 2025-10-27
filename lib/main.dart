import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/app_theme.dart';
import 'core/providers/app_providers.dart';
import 'core/navigation/app_router.dart';
import 'core/config/app_config.dart';
import 'l10n/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize localization
  await _initializeLocalization();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    const ProviderScope(
      child: CampusTerangaApp(),
    ),
  );
}

/// Initialize localization
Future<void> _initializeLocalization() async {
  // Set default locale
  Intl.defaultLocale = L10n.defaultLocale.languageCode;
  
  // Initialize date formatting for supported locales
  await initializeDateFormatting(L10n.defaultLocale.languageCode);
}

class CampusTerangaApp extends ConsumerWidget {
  const CampusTerangaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isDarkTheme = ref.watch(appThemeModeProvider);
    
    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      
      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      
      // Router configuration
      routerConfig: router,
      
      // Localization
      locale: L10n.defaultLocale,
      supportedLocales: L10n.supportedLocales,
      localizationsDelegates: L10n.delegates,
      
      // Builder for global error handling
      builder: (context, child) {
        return MediaQuery(
          // Ensure text doesn't scale beyond reasonable limits
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.3,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}