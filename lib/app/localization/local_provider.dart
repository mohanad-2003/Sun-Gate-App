
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale?>((
  ref,
) {
  return AppLocaleNotifier()..loadSavedLocale();
});

class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier() : super(const Locale('en'));
  static const String _localeKey = 'app_locale';

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey) ?? 'en';
    state = Locale(languageCode);
  }

  Future<void> changeLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, code);
    state = Locale(code);
  }

  Future<void> setEnglish() async {
    await changeLanguage('en');
  }

  Future<void> setArabic() async {
    await changeLanguage('ar');
  }

 
}
