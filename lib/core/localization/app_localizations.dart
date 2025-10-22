import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// App-specific localizations for Campus Téranga
/// 
/// This class provides localized strings for the app
/// in French (default) and English
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = [
    Locale('fr', 'SN'), // French - Senegal
    Locale('en', 'US'), // English - US
  ];

  // App-specific strings
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get register => _localizedValues[locale.languageCode]!['register']!;
  String get formations => _localizedValues[locale.languageCode]!['formations']!;
  String get services => _localizedValues[locale.languageCode]!['services']!;
  String get events => _localizedValues[locale.languageCode]!['events']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get confirm => _localizedValues[locale.languageCode]!['confirm']!;

  static final Map<String, Map<String, String>> _localizedValues = {
    'fr': {
      'appTitle': 'Campus Téranga',
      'welcome': 'Bienvenue',
      'login': 'Se connecter',
      'register': 'S\'inscrire',
      'formations': 'Formations',
      'services': 'Services',
      'events': 'Événements',
      'profile': 'Profil',
      'home': 'Accueil',
      'loading': 'Chargement...',
      'error': 'Erreur',
      'success': 'Succès',
      'cancel': 'Annuler',
      'save': 'Enregistrer',
      'edit': 'Modifier',
      'delete': 'Supprimer',
      'confirm': 'Confirmer',
    },
    'en': {
      'appTitle': 'Campus Téranga',
      'welcome': 'Welcome',
      'login': 'Login',
      'register': 'Register',
      'formations': 'Formations',
      'services': 'Services',
      'events': 'Events',
      'profile': 'Profile',
      'home': 'Home',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'cancel': 'Cancel',
      'save': 'Save',
      'edit': 'Edit',
      'delete': 'Delete',
      'confirm': 'Confirm',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['fr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
