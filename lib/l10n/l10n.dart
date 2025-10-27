import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'app_localizations.dart';

/// Localization Configuration
/// 
/// This class provides centralized localization configuration
/// for the Flutter application.

class L10n {
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('fr', ''), // French
  ];

  // Default locale
  static const Locale defaultLocale = Locale('fr', ''); // French as default

  // Localization delegates
  static const List<LocalizationsDelegate> delegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  // Date format for different locales
  static String formatDate(DateTime date, Locale locale) {
    final localeString = locale.languageCode;
    final formatter = DateFormat.yMMMd(localeString);
    return formatter.format(date);
  }

  // Time format for different locales
  static String formatTime(DateTime time, Locale locale) {
    final localeString = locale.languageCode;
    final formatter = DateFormat.Hm(localeString);
    return formatter.format(time);
  }

  // DateTime format for different locales
  static String formatDateTime(DateTime dateTime, Locale locale) {
    final localeString = locale.languageCode;
    final formatter = DateFormat.yMMMd(localeString).add_Hm();
    return formatter.format(dateTime);
  }

  // Number format for different locales
  static String formatNumber(num number, Locale locale) {
    final localeString = locale.languageCode;
    final formatter = NumberFormat.decimalPattern(localeString);
    return formatter.format(number);
  }

  // Currency format for different locales
  static String formatCurrency(num amount, Locale locale, {String? currencyCode}) {
    final localeString = locale.languageCode;
    final formatter = NumberFormat.currency(
      locale: localeString,
      symbol: currencyCode ?? 'XOF', // West African CFA franc
    );
    return formatter.format(amount);
  }

  // Get locale display name
  static String getLocaleDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode.toUpperCase();
    }
  }

  // Get locale flag emoji
  static String getLocaleFlag(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'fr':
        return '🇫🇷';
      default:
        return '🌍';
    }
  }

  // Check if locale is RTL
  static bool isRTL(Locale locale) {
    // Currently no RTL languages supported
    return false;
  }
}
