import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

final appLocaleProvider =
    StateNotifierProvider<AppLocaleNotifier, Locale?>((ref) {
  return AppLocaleNotifier();
});

class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier() : super(const Locale('en'));

  void setEnglish() {
    state = const Locale('en');
  }

  void setArabic() {
    state = const Locale('ar');
  }

  void changeLanguage(String code) {
    state = Locale(code);
  }
}