import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../../l10n/l10n.dart';

/// Localization Service
/// 
/// This service handles language preferences and locale management
/// for the Flutter application.

class LocalizationService extends ChangeNotifier {
  static const String _languageKey = AppConstants.languageKey;
  
  Locale _currentLocale = L10n.defaultLocale;
  bool _isInitialized = false;

  // Getters
  Locale get currentLocale => _currentLocale;
  bool get isInitialized => _isInitialized;
  String get currentLanguageCode => _currentLocale.languageCode;
  String get currentLanguageDisplayName => L10n.getLocaleDisplayName(_currentLocale);
  String get currentLanguageFlag => L10n.getLocaleFlag(_currentLocale);

  /// Initialize the localization service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);
      
      if (savedLanguageCode != null) {
        final savedLocale = Locale(savedLanguageCode);
        if (L10n.supportedLocales.contains(savedLocale)) {
          _currentLocale = savedLocale;
        }
      }
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      // If initialization fails, use default locale
      _currentLocale = L10n.defaultLocale;
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Change the current locale
  Future<void> changeLocale(Locale locale) async {
    if (!L10n.supportedLocales.contains(locale)) {
      throw ArgumentError('Unsupported locale: $locale');
    }

    if (_currentLocale == locale) return;

    _currentLocale = locale;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      // If saving fails, the change is still applied in memory
      // The user will see the change but it won't persist
    }
  }

  /// Get supported locales
  List<Locale> get supportedLocales => L10n.supportedLocales;

  /// Get locale display name
  String getLocaleDisplayName(Locale locale) {
    return L10n.getLocaleDisplayName(locale);
  }

  /// Get locale flag
  String getLocaleFlag(Locale locale) {
    return L10n.getLocaleFlag(locale);
  }

  /// Check if locale is RTL
  bool isRTL(Locale locale) {
    return L10n.isRTL(locale);
  }

  /// Format date for current locale
  String formatDate(DateTime date) {
    return L10n.formatDate(date, _currentLocale);
  }

  /// Format time for current locale
  String formatTime(DateTime time) {
    return L10n.formatTime(time, _currentLocale);
  }

  /// Format date and time for current locale
  String formatDateTime(DateTime dateTime) {
    return L10n.formatDateTime(dateTime, _currentLocale);
  }

  /// Format number for current locale
  String formatNumber(num number) {
    return L10n.formatNumber(number, _currentLocale);
  }

  /// Format currency for current locale
  String formatCurrency(num amount, {String? currencyCode}) {
    return L10n.formatCurrency(amount, _currentLocale, currencyCode: currencyCode);
  }

  /// Reset to default locale
  Future<void> resetToDefault() async {
    await changeLocale(L10n.defaultLocale);
  }

  /// Get all supported locales with display names
  List<Map<String, dynamic>> getSupportedLocalesWithInfo() {
    return L10n.supportedLocales.map((locale) => {
      'locale': locale,
      'displayName': getLocaleDisplayName(locale),
      'flag': getLocaleFlag(locale),
      'isRTL': isRTL(locale),
    }).toList();
  }
}
